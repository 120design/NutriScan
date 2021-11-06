//
//  SearchViewModelTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 04/11/2021.
//

import XCTest
@testable import NutriScan
import SwiftUI

class SearchViewModelTestCase: XCTestCase {
    var sut: SearchViewModel!
    let foundProduct = MockResponseData.enumProductA
    
    var expectation: XCTestExpectation!
    let timeOut = 1.0
    
    var mockOFFService: MockOFFService!
    
    override func setUp() {
        super.setUp()
        
        mockOFFService = MockOFFService()
        
        sut = SearchViewModel(
            storageManager: MockStorageManager(),
            offService: mockOFFService
        )
        
        expectation = expectation(description: "OFFServiceTestCase expectation")
    }
    
    override func tearDown() {
        sut = nil
        expectation = nil
        
        super.tearDown()
    }
    
    func testGivenCorrectEANCode_WhenGetProduct_ThenProductGetted() {
        // Given
        sut.eanCode = "12345678"
        mockOFFService.nuProduct = foundProduct
        
        // When
        sut.getProduct()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertEqual(self.sut.foundProduct, self.foundProduct)
            XCTAssertFalse(self.sut.currentlyResearching)
            XCTAssertTrue(self.sut.showResult)
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenBadEANCode_WhenGetProduct_ThenProductGetted() {
        // Given
        sut.eanCode = "123"
        mockOFFService.nuProduct = foundProduct
        
        // When
        sut.getProduct()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertEqual(self.sut.foundProduct, nil)
            XCTAssertFalse(self.sut.currentlyResearching)
            XCTAssertFalse(self.sut.showResult)
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenEANCode_WhenInvalidCharacterAdded_ThenEANCodeIsNotModified() {
        // Given
        sut.eanCode = "123"
        
        // When
        sut.eanCode = "123A"
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertEqual(self.sut.eanCode, "123")
            XCTAssertFalse(self.sut.clearButtonIsDisabled)
            XCTAssertTrue(self.sut.searchButtonIsDisabled)
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenEANCodeHas13Characters_WhenAnotherCharacterAdded_ThenEANCodeIsNotModified() {
        // Given
        sut.eanCode = "1234567891012"
        
        // When
        sut.eanCode = "12345678910123"
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertEqual(self.sut.eanCode, "1234567891012")
            XCTAssertFalse(self.sut.clearButtonIsDisabled)
            XCTAssertFalse(self.sut.searchButtonIsDisabled)
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenGetProductsProducesConnectionError_WhenGetProducts_ThenConnectionErrorIsHandled() {
        // Given
        mockOFFService.offError = .connection
        
        // When
        sut.eanCode = "01234567"
        sut.getProduct()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertFalse(self.sut.currentlyResearching)
            XCTAssertTrue(self.sut.alertViewModel.isPresented)
            XCTAssertEqual(self.sut.alertViewModel.title, "Problème de connexion")
            XCTAssertEqual(self.sut.alertViewModel.message, "Votre appareil n’est pas connecté au web, merci de vérifier votre connexion avant de lancer une recherche.")
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenGetProductsProducesNoProductFoundError_WhenGetProducts_ThenNoProductFoundErrorIsHandled() {
        // Given
        mockOFFService.offError = .noProductFound
        
        // When
        sut.eanCode = "01234567"
        sut.getProduct()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertFalse(self.sut.currentlyResearching)
            XCTAssertTrue(self.sut.alertViewModel.isPresented)
            XCTAssertEqual(self.sut.alertViewModel.title, "Pas de produit trouvé")
            XCTAssertEqual(self.sut.alertViewModel.message, "Aucun produit correspondant au code EAN 01234567 n’a été trouvé dans la base de données d’Open Food Facts. Il pourrait être ajouté ultérieurement, alors n’hésitez pas à ré-essayer une autre fois.")
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenGetProductsProducesUndefinedError_WhenGetProducts_ThenUndefinedErrorIsHandled() {
        // Given
        mockOFFService.offError = .undefined
        
        // When
        sut.eanCode = "01234567"
        sut.getProduct()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertFalse(self.sut.currentlyResearching)
            XCTAssertTrue(self.sut.alertViewModel.isPresented)
            XCTAssertEqual(self.sut.alertViewModel.title, "Erreur indéterminée")
            XCTAssertEqual(self.sut.alertViewModel.message, "Une erreur est survenue, merci de ré-essayer ultérieurement.")
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenGetProductsProducesCancelledRequestError_WhenGetProducts_ThenCancelledRequestErrorIsHandled() {
        // Given
        mockOFFService.offError = .cancelledRequest
        
        // When
        sut.eanCode = "01234567"
        sut.getProduct()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
            XCTAssertFalse(self.sut.currentlyResearching)
            XCTAssertFalse(self.sut.showCardDetail)

            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenGetProducts_WhenCancelRequest_ThenNoFoundProduct() {
        // Given
        sut.eanCode = "01234567"
        sut.getProduct()
        
        // When
        sut.cancelRequest()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {
            XCTAssertNil(self.sut.foundProduct)

            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGiven_WhenGetProducts_ThenUndefinedErrorIsHandled() {
        // Given
        
        // When
        sut = nil
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + timeOut) {

            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
}
