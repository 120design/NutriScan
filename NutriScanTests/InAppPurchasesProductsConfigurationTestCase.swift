//
//  InAppPurchasesProductsConfigurationTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 05/11/2021.
//

import XCTest
@testable import NutriScan

class InAppPurchasesProductsConfigurationTestCase: XCTestCase {
    typealias sut = InAppPurchasesProductsConfiguration
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
//        sut = nil
        
        super.tearDown()
    }
    
    func testGivenFavoritesProductsAndAccessIsGranted_WhenGetFavorites_ThenFavoritesAreGetted() {
        // Given
        let productsIDs  = sut.readConfigFile()
        
        // Then
        XCTAssertNotNil(productsIDs)
    }
}
