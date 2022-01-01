//
//  InAppPurchasesViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 28/10/2021.
//

import StoreKit

typealias ProductID = String

// The state of a purchase.
enum PurchaseState {
    case notStarted,
         userCannotMakePayments,
         inProgress,
         purchased,
         pending,
         cancelled,
         failed,
         failedVerification,
         unknown
}

// Information on the result of unwrapping a transaction `VerificationResult`.
struct UnwrappedVerificationResult<T> {
    // The verified or unverified transaction.
    let transaction: T
    
    // True if the transaction was successfully verified by StoreKit.
    let verified: Bool
    
    // If `verified` is false then `verificationError` will hold the verification error, nil otherwise.
    let verificationError: VerificationResult<T>.VerificationError?
}

class InAppPurchasesViewModel: ObservableObject  {
    @Published internal var paidVersionIsPurchased: Bool?
    
    private var products: [Product]?
    private let productIDs: Set<String> = ["design.120.NutriScan.PaidVersion"]
    
    private var purchasedProductsIDs: [String] = []

    private(set) var purchaseState: PurchaseState = .notStarted
    
    // Handle for App Store transactions.
    private var transactionListener: Task<Void, Error>? = nil
    
    private let canMakePayments: Bool
            
    @MainActor
    init(
        canMakePayments: Bool = AppStore.canMakePayments,
        providedProducts: [Product]? = nil
    ) {
        self.canMakePayments = canMakePayments

        transactionListener = handleTransactions()
        
        Task {
            products = try? await Product.products(for: productIDs)
            paidVersionIsPurchased = await isPaidVersionPurchased()
        }
    }
    
    deinit { transactionListener?.cancel() }
    
    @MainActor
    func purchasePaidVersion() async throws -> PurchaseState {
        guard let product = products?.first
        else {
            print("InAppPurchasesViewModel ~> purchasePaidVersion ~> No product to sell")
            return .unknown
        }
        
        guard canMakePayments else {
            print("InAppPurchasesViewModel ~> purchasePaidVersion ~> Purchase failed because the user cannot make payments")
            return .userCannotMakePayments
        }
        
        guard purchaseState != .inProgress else {
            print("InAppPurchasesViewModel ~> purchasePaidVersion ~> EXCEPTION ~> StoreKit throw an exception while processing a purchase")
            throw StoreException.purchaseInProgressException
        }
        
        // Start a purchase transaction
        purchaseState = .inProgress
        print("InAppPurchasesViewModel ~> purchasePaidVersion ~> product.id ~>", product.id, "~> Purchase in progress")
        
        guard let result = try? await product.purchase() else {
            purchaseState = .failed
            print("InAppPurchasesViewModel ~> purchasePaidVersion ~> EXCEPTION ~> product.id ~>", product.id, "~> Purchase failure")
            throw StoreException.purchaseException
        }
        
        // Every time an app receives a transaction from StoreKit 2, the transaction has already passed through a
        // verification process to confirm whether the payload is signed by the App Store for my app for this device.
        // That is, Storekit2 does transaction (receipt) verification for you (no more OpenSSL or needing to send
        // a receipt to an Apple server for verification).
        
        // We now have a PurchaseResult value. See if the purchase suceeded, failed, was cancelled or is pending.
        switch result {
            case .success(let verificationResult):
                // The purchase seems to have succeeded. StoreKit has already automatically attempted to validate
                // the transaction, returning the result of this validation wrapped in a `VerificationResult`.
                // We now need to check the `VerificationResult<Transaction>` to see if the transaction passed the
                // App Store's validation process. This is equivalent to receipt validation in StoreKit1.
                
                // Did the transaction pass StoreKit’s automatic validation?
                let checkResult = checkVerificationResult(result: verificationResult)
                if !checkResult.verified {
                    purchaseState = .failedVerification
                    print("InAppPurchasesViewModel ~> purchasePaidVersion ~> TRANSACTION VALIDATION FAILURE ~> checkResult.transaction.productID ~>", checkResult.transaction.productID)
                    paidVersionIsPurchased = false
                    throw StoreException.transactionVerificationFailed
                }
                
                // The transaction was successfully validated.
                let validatedTransaction = checkResult.transaction
                
                // Update the list of purchased ids. Because it's is a @Published var this will cause the UI
                // showing the list of products to update
                await updatePurchasedIdentifiers(validatedTransaction)
                
                // Tell the App Store we delivered the purchased content to the user
                await validatedTransaction.finish()
                
                // Let the caller know the purchase succeeded and that the user should be given access to the product
                purchaseState = .purchased
                paidVersionIsPurchased = true
                print("InAppPurchasesViewModel ~> purchasePaidVersion ~> NOTIFICATION ~> product.id ~>", product.id, "~>", StoreNotification.purchaseSuccess)
                
                return .purchased
                
            case .userCancelled:
                purchaseState = .cancelled
                print("InAppPurchasesViewModel ~> purchasePaidVersion ~>  product.id ~>", product.id, "~> .cancelled")
                paidVersionIsPurchased = false
                return .cancelled
                
            case .pending:
                purchaseState = .pending
                print("InAppPurchasesViewModel ~> purchasePaidVersion ~>  product.id ~>", product.id, "~> .pending")
                return .pending
                
            default:
                purchaseState = .unknown
                print("InAppPurchasesViewModel ~> purchasePaidVersion ~>  product.id ~>", product.id, "~> .unknown")
                paidVersionIsPurchased = false
                return .unknown
        }
    }
    
    @MainActor
    internal func isPaidVersionPurchased() async -> Bool {
        guard let productID = products?
                .first(where: { $0.id == "design.120.NutriScan.PaidVersion"})?
                .id,
              let isPurchased = try? await isPurchased(productID: productID)
        else { return false }
        
        return isPurchased
    }

    // Requests the most recent transaction for a product from the App Store and determines if it has been previously purchased.
    // May throw an exception of type `StoreException.transactionVerificationFailed`.
    // - Parameter productId: The `ProductID` of the product.
    // - Returns: Returns true if the product has been purchased, false otherwise.
    @MainActor
    private func isPurchased(productID: ProductID) async throws -> Bool {
        guard let currentEntitlement = await Transaction.currentEntitlement(for: productID)
        else { return false  /* There's no transaction for the product, so it hasn't been purchased */ }
        
        // See if the transaction passed StoreKit's automatic verification
        let result = checkVerificationResult(result: currentEntitlement)
        if !result.verified {
            print("InAppPurchasesViewModel ~> isPurchased ~> result.transaction.productID ~>", result.transaction.productID, "~> .transactionValidationFailure")
            throw StoreException.transactionVerificationFailed
        }
        
        // Make sure our internal set of purchase pids is in-sync with the App Store
        await updatePurchasedIdentifiers(result.transaction)
        
        // See if the App Store has revoked the users access to the product (e.g. because of a refund).
        return result.transaction.revocationDate == nil
    }
        
    // Uses StoreKit's `Transaction.currentEntitlements` property to iterate over the sequence of `VerificationResult<Transaction>`
    // representing all transactions for products the user is currently entitled to. That is, all currently-subscribed
    // transactions and all purchased (and not refunded) non-consumables. Note that transactions for consumables are NOT
    // in the receipt.
    // - Returns: A verified `Set<ProductId>` for all products the user is entitled to have access to. The set will be empty if the
    // user has not purchased anything previously.
    @MainActor
    private func currentEntitlements() async -> Set<ProductID> {
        var entitledProductIDs = Set<ProductID>()
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                entitledProductIDs.insert(transaction.productID)  // Ignore unverified transactions
            }
        }
        
        return entitledProductIDs
    }
    
    // The `Product` associated with a `ProductID`.
    // - Parameter productId: `ProductID`.
    // - Returns: Returns the `Product` associated with a `ProductID`.
    private func getProduct(from productID: ProductID) -> Product? {
        guard let products = products
        else { return nil }
        
        let matchingProduct = products.filter { $0.id == productID }
        
        guard matchingProduct.count == 1
        else { return nil }
        
        return matchingProduct.first
    }
    
    // This is an infinite async sequence (loop). It will continue waiting for transactions until it is explicitly
    // canceled by calling the Task.cancel() method. See `transactionListener`.
    // - Returns: Returns a task for the transaction handling loop task.
    @MainActor
    private func handleTransactions() -> Task<Void, Error> {
        Task.detached {
            for await verificationResult in Transaction.updates {
                // See if StoreKit validated the transaction
                let checkResult = await self.checkVerificationResult(result: verificationResult)
                print("InAppPurchasesViewModel ~> handleTransactions ~> checkResult.transaction.productID ~>", checkResult.transaction.productID)
                
                if checkResult.verified {
                    let validatedTransaction = checkResult.transaction
                    
                    // The transaction was validated so update the list of products the user has access to
                    await self.updatePurchasedIdentifiers(validatedTransaction)
                    
                    await validatedTransaction.finish()
                } else {
                    // StoreKit's attempts to validate the transaction failed. Don't deliver content to the user.
//                    StoreLog.transaction(.transactionFailure, productId: checkResult.transaction.productID)
                    print("InAppPurchasesViewModel ~> handleTransactions ~> ERROR ~> checkResult.transaction.productID ~>", checkResult.transaction.productID)
                }
            }
        }
    }
    
    // Check if StoreKit was able to automatically verify a transaction by inspecting the verification result.
    // - Parameter result: The transaction VerificationResult to check.
    // - Returns: Returns an `UnwrappedVerificationResult<T>` where `verified` is true if the transaction was
    // successfully verified by StoreKit. When `verified` is false `verificationError` will be non-nil.
    @MainActor
    private func checkVerificationResult<T>(result: VerificationResult<T>) -> UnwrappedVerificationResult<T> {
        switch result {
            case .unverified(let unverifiedTransaction, let error):
                // StoreKit failed to automatically validate the transaction
                return UnwrappedVerificationResult(transaction: unverifiedTransaction, verified: false, verificationError: error)
            case .verified(let verifiedTransaction):
                // StoreKit successfully automatically validated the transaction
                return UnwrappedVerificationResult(transaction: verifiedTransaction, verified: true, verificationError: nil)
        }
    }
    
    
    // Update our list of purchased product identifiers (see `purchasedProducts`).
    // This method runs on the main thread because it will result in updates to the UI.
    // - Parameter transaction: The `Transaction` that will result in changes to `purchasedProducts`.
    @MainActor
    private func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        let productID = transaction.productID
        
        if transaction.revocationDate == nil {
            // The transaction has NOT been revoked by the App Store so this product has been purchase.
            // Add the ProductId to the list of `purchasedProductsIDs` (it's a Set so it won't add if already there).
            if purchasedProductsIDs.contains(productID) { return }
            purchasedProductsIDs.append(productID)
        } else {
            // The App Store revoked this transaction (e.g. a refund), meaning the user should not have access to it.
            // Remove the product from the list of `purchasedProducts`.
            if let index = purchasedProductsIDs.firstIndex(where: { $0 == productID}) {
                purchasedProductsIDs.remove(at: index)
            }
        }
    }
    
    // TODO: Replace by a real method for handle refund
    func getFreeVersion() {
        paidVersionIsPurchased = false
    }
    
//    func fetchProducts() async {
//        do {
//            let products = try await Product.products(for: ["design.120.NutriScan.211028-0948"])
//            DispatchQueue.main.async {
//                self.products = products
//            }
//
//            if let product = products.first {
//                await isPurchased(product: product)
//            }
//        } catch {
//            print("InAppPurchaseViewModel ~> fetchProducts ~> error ~>", error)
//        }
//    }
//
//    func isPurchased(product: Product) async {
//        guard let state = await product.currentEntitlement
//        else { return }
//
//        switch state {
//        case .verified(let transaction):
//            print("verified")
//            DispatchQueue.main.async {
//                self.purchasedIds.append(transaction.productID)
//            }
//        case .unverified(_, _):
//            print("unverified")
//            break
//        }
//    }
    
//    func purchase() async {
//        guard let product = products.first else { return }
//
//        do {
//            let result = try await product.purchase()
//            switch result {
//            case .success(let verification):
//                switch verification {
//                case .verified(let transaction):
//                    print(transaction.productID)
//                case .unverified(_, _):
//                    break
//                }
//            case .userCancelled:
//                break
//            case .pending:
//                break
//            @unknown default:
//                break
//            }
//        } catch {
//            print(error)
//        }
//    }
}

extension InAppPurchasesViewModel {
    // StoreHelper exceptions
    enum StoreException: Error, Equatable {
        case purchaseException
        case purchaseInProgressException
        case transactionVerificationFailed
        
        public func shortDescription() -> String {
            switch self {
                case .purchaseException:                    return "Exception. StoreKit throw an exception while processing a purchase"
                case .purchaseInProgressException:          return "Exception. You can't start another purchase yet, one is already in progress"
                case .transactionVerificationFailed:        return "Exception. A transaction failed StoreKit's automatic verification"
            }
        }
    }
    
    // Informational logging notifications issued by InAppPurchasesViewModel
    enum StoreNotification: Error, Equatable {
        case configurationNotFound
        case configurationEmpty
        case configurationSuccess
        case configurationFailure
        
        case requestProductsStarted
        case requestProductsSuccess
        case requestProductsFailure
        
        case purchaseUserCannotMakePayments
        case purchaseAlreadyInProgress
        case purchaseInProgress
        case purchaseCancelled
        case purchasePending
        case purchaseSuccess
        case purchaseFailure
        
        case transactionReceived
        case transactionValidationSuccess
        case transactionValidationFailure
        case transactionFailure
        case transactionSuccess
        case transactionRevoked
        case transactionRefundRequested
        case transactionRefundFailed
        
        case consumableSavedInKeychain
        case consumableKeychainError
        
        /// A short description of the notification.
        /// - Returns: Returns a short description of the notification.
        public func shortDescription() -> String {
            switch self {
                case .configurationNotFound:           return "Configuration file not found in the main bundle"
                case .configurationEmpty:              return "Configuration file does not contain any product definitions"
                case .configurationSuccess:            return "Configuration success"
                case .configurationFailure:            return "Configuration failure"
                    
                case .requestProductsStarted:          return "Request products from the App Store started"
                case .requestProductsSuccess:          return "Request products from the App Store success"
                case .requestProductsFailure:          return "Request products from the App Store failure"
                    
                case .purchaseUserCannotMakePayments:  return "Purchase failed because the user cannot make payments"
                case .purchaseAlreadyInProgress:       return "Purchase already in progress"
                case .purchaseInProgress:              return "Purchase in progress"
                case .purchasePending:                 return "Purchase in progress. Awaiting authorization"
                case .purchaseCancelled:               return "Purchase cancelled"
                case .purchaseSuccess:                 return "Purchase success"
                case .purchaseFailure:                 return "Purchase failure"
                    
                case .transactionReceived:             return "Transaction received"
                case .transactionValidationSuccess:    return "Transaction validation success"
                case .transactionValidationFailure:    return "Transaction validation failure"
                case .transactionFailure:              return "Transaction failure"
                case .transactionSuccess:              return "Transaction success"
                case .transactionRevoked:              return "Transaction was revoked (refunded) by the App Store"
                case .transactionRefundRequested:      return "Transaction refund successfully requested"
                case .transactionRefundFailed:         return "Transaction refund request failed"
                    
                case .consumableSavedInKeychain:       return "Consumable purchase successfully saved to the keychain"
                case .consumableKeychainError:         return "Keychain error"
            }
        }
    }
}

