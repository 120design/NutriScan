//
//  HistoryViewModelTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 02/11/2021.
//

import XCTest
@testable import NutriScan

class HistoryViewModelTestCase: XCTestCase {
    var sut: HistoryViewModel!
    
    override func setUp() {
        super.setUp()
        
        let storageManger = MockStorageManager()
        storageManger.historyNUProducts = [
            MockResponseData.enumProductA,
            MockResponseData.enumProductB
        ]

        sut = HistoryViewModel(storageManager: storageManger)
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testGivenProductsHistory_WhenGetHistoryProducts_ThenProductsAreGetted() {
        // Given
        
        // When
        sut.getHistoryProducts()
        
        // Then
        XCTAssertEqual(sut.products, [
            MockResponseData.enumProductA,
            MockResponseData.enumProductB
        ])
    }
}
