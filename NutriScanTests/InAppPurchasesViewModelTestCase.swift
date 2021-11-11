//
//  InAppPurchasesViewModelTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 06/11/2021.
//

import XCTest
@testable import NutriScan
import StoreKit

class InAppPurchasesViewModelTestCase: XCTestCase {
    var sut: InAppPurchasesViewModel!
    
    func readNilConfigFile() -> Set<ProductID>? { nil }
    func readNotNilConfigFile() -> Set<ProductID>? { ["123"] }
    let providedProductID = "design.120.NutriScan.PaidVersion"
    
    typealias StoreException = InAppPurchasesViewModel.StoreException
    
    var purchaseState: PurchaseState = .notStarted
    var purchasePaidVersionError: Error?
    
    override func tearDown() {
        sut = nil
        purchaseState = .notStarted
        purchasePaidVersionError = nil
        
        super.tearDown()
    }
    
    func testGivenReadNilConfigFile_WhenPurchasePaidVersion_ThenPurchaseStateIsUnknow() async {
        // Given
        sut = await InAppPurchasesViewModel(readConfigFile: readNilConfigFile)
        
        // When
        do {
            self.purchaseState = try await sut.purchasePaidVersion()

            // Then
            XCTAssertNil(self.purchasePaidVersionError)
            XCTAssertEqual(self.purchaseState, .unknown)
        } catch {
            purchasePaidVersionError = error
        }
    }
    
    func testGivenUserCantMakePayments_WhenPurchasePaidVersion_ThenPurchaseStateIsUserCantMakePayment() async {
        // Given
        // When
        do {
            let products = try await Product.products(for: [providedProductID])

            sut = await InAppPurchasesViewModel(
                canMakePayments: false,
                providedProducts: products
            )
            
            self.purchaseState = try await sut.purchasePaidVersion()
            
            // Then
            XCTAssertEqual(self.purchaseState, .userCannotMakePayments)
        } catch {
            purchasePaidVersionError = error
        }
    }
    
    func testGivenUserCanMakePayments_WhenPurchasePaidVersion_ThenPurchaseStateIsPurchased() async {
        // Given
        // When
        do {
            let products = try await Product.products(for: [providedProductID])

            sut = await InAppPurchasesViewModel(
                canMakePayments: true,
                providedProducts: products
            )
            
            self.purchaseState = try await sut.purchasePaidVersion()
            
            // Then
            XCTAssertEqual(self.purchaseState, .purchased)
        } catch {
            purchasePaidVersionError = error
        }
    }
}
