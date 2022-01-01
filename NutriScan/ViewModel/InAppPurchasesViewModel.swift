//
//  InAppPurchasesViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 28/10/2021.
//

import StoreKit

// The state of a purchase.
enum PurchaseState {
    case notStarted,
         userCannotMakePayments,
         started,
         purchased,
         pending,
         cancelled,
         failed,
         failedVerification,
         unknown
}

class InAppPurchasesViewModel: ObservableObject  {
    @Published internal var paidVersionIsPurchased: Bool?
    
    private var products: [Product]?
    private let productIDs: Set<String> = ["design.120.NutriScan.PaidVersion"]
    
    private var purchaseState: PurchaseState = .notStarted
    
    // Handle for App Store transactions.
    private var transactionListener: Task<Void, Error>? = nil
    
    @MainActor
    init() {
        transactionListener = handleTransactions()
        
        Task {
            products = try? await Product.products(for: productIDs)
            paidVersionIsPurchased = await isPaidVersionPurchased()
        }
    }
    
    deinit { transactionListener?.cancel() }
    
    
    // This is an infinite async sequence (loop). It will continue waiting for transactions until it is explicitly
    // canceled by calling the Task.cancel() method. See `transactionListener`.
    // - Returns: Returns a task for the transaction handling loop task.
    @MainActor
    private func handleTransactions() -> Task<Void, Error> {
        Task.detached {
            for await verificationResult in Transaction.updates {
                switch verificationResult {
                case .unverified:
                    break
                case .verified(let verifiedTransaction):
                    guard verifiedTransaction.productID ==
                            "design.120.NutriScan.PaidVersion"
                    else { break }
                }
            }
        }
    }
    
    @MainActor
    func purchasePaidVersion() async throws {
        guard let product = products?.first
        else {
            return
        }
        
        guard AppStore.canMakePayments  else {
            purchaseState = .userCannotMakePayments
            return
        }
        
        guard purchaseState != .started else {
            throw StoreError.purchaseInProgressException
        }
        
        // Start a purchase transaction
        purchaseState = .started
        
        guard let result = try? await product.purchase() else {
            purchaseState = .failed
            throw StoreError.purchaseException
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
            
            var validatedTransaction: Transaction
            
            switch verificationResult {
            case .unverified:
                purchaseState = .failedVerification
                throw StoreError.transactionVerificationFailed
            case .verified(let verifiedTransaction):
                validatedTransaction = verifiedTransaction
            }
            
            purchaseState = .purchased
            paidVersionIsPurchased = true
            
            await validatedTransaction.finish()
            
        case .userCancelled:
            purchaseState = .cancelled
            paidVersionIsPurchased = false
            
        case .pending:
            purchaseState = .pending
            return
            
        default:
            purchaseState = .unknown
            paidVersionIsPurchased = false
            return
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
    private func isPurchased(productID: String) async throws -> Bool {
        guard let verificationResult = await
                Transaction.currentEntitlement(for: productID)
        else { return false }
        
        return try verify(verificationResult: verificationResult)
    }
    
    @MainActor
    private func verify(
        verificationResult: VerificationResult<Transaction>
    ) throws -> Bool {
        switch verificationResult {
        case .unverified:
            throw StoreError.transactionVerificationFailed
        case .verified(let verifiedTransaction):
            if let _ = verifiedTransaction.revocationDate {
                throw StoreError.refundedPurchase
            }
            return true
        }
    }
    
    func restorePurchases() {
        Task {
            //This call displays a system prompt that asks users to authenticate with their App Store credentials.
            //Call this function only in response to an explicit user action, such as tapping a button.
            try? await AppStore.sync()
        }
    }
}

extension InAppPurchasesViewModel {
    // StoreHelper exceptions
    enum StoreError: Error, Equatable {
        case purchaseException
        case purchaseInProgressException
        case transactionVerificationFailed
        case refundedPurchase
        
        public func shortDescription() -> String {
            switch self {
            case .purchaseException:                    return "Exception. StoreKit throw an exception while processing a purchase"
            case .purchaseInProgressException:          return "Exception. You can't start another purchase yet, one is already in progress"
            case .transactionVerificationFailed:        return "Exception. A transaction failed StoreKit's automatic verification"
            case .refundedPurchase:                     return "Exception. The product has been refunded"
            }
        }
    }
}

