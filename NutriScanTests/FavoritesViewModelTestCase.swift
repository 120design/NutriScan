//
//  FavoritesViewModelTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 02/11/2021.
//

import XCTest
@testable import NutriScan

class FavoritesViewModelTestCase: XCTestCase {
    var sut: FavoritesViewModel!
    
    let sampleNUProducts = [
        MockResponseData.enumProductA,
        MockResponseData.enumProductB,
        MockResponseData.enumProductC
    ]
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testGivenFavoritesProductsAndAccessIsGranted_WhenGetFavorites_ThenFavoritesAreGetted() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        sut.getFavoritesProducts()
        
        // Then
        XCTAssertEqual(sut.products, sampleNUProducts)
    }

    func testGivenFavoritesProductsAndAccessIsNotGranted_WhenGetFavorites_ThenFavoritesAreEmpty() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = false

        // When
        sut.getFavoritesProducts()
        
        // Then
        XCTAssertEqual(sut.products, [])
    }

    func testGivenFavoritesProductsAndAccessIsGranted_WhenAddFavorite_ThenFavoriteIsAdded() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        let productAdded = MockResponseData.enumProductDWithTransportationValue
        sut.addProductToFavorites(productAdded)
        
        // Then
        XCTAssertEqual(sut.products, [productAdded] + sampleNUProducts)
    }

    func testGivenFavoritesProductsAndAccessIsGranted_WhenRemoveFavorite_ThenFavoriteIsRemoved() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        let productRemoved = MockResponseData.enumProductDWithTransportationValue
        sut.removeProductFromFavorites(productRemoved)
        
        // Then
        XCTAssertFalse(sut.products.contains(productRemoved))
        XCTAssertEqual(sut.products, sampleNUProducts)
    }
    
    func testGivenFavoritesProductsAndAccessIsGranted_WhenRemoveIndexSet_ThenFavoriteIsRemoved() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        sut.removeProductFromFavorites(indexSet: IndexSet(integer: 0))
        
        // Then
        XCTAssertFalse(sut.products.contains(sampleNUProducts[0]))
    }
    
    func testGivenFavoritesProductsAndAccessIsGranted_WhenMoveProductDown_ThenProductHasMoved() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        sut.moveProduct(from: IndexSet(integer: 0), to: 3)
        
        // Then
        XCTAssertEqual(sut.products, [
            MockResponseData.enumProductB,
            MockResponseData.enumProductC,
            MockResponseData.enumProductA
       ])
    }
    
    func testGivenFavoritesProductsAndAccessIsGranted_WhenMoveProductUp_ThenProductHasMoved() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        sut.moveProduct(from: IndexSet(integer: 1), to: 0)
        
        // Then
        XCTAssertEqual(sut.products, [
            MockResponseData.enumProductB,
            MockResponseData.enumProductA,
            MockResponseData.enumProductC
        ])
    }
    
    func testGivenFavoritesProductsContainProduct_WhenTellIfProductIsAFavorite_ThenTrue() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        let bool = sut.productIsAFavorite(MockResponseData.enumProductA)
        
        // Then
        XCTAssertTrue(bool)
    }
    
    func testGivenFavoritesProductsDontContainProduct_WhenTellIfProductIsAFavorite_ThenFalse() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        let bool = sut.productIsAFavorite(MockResponseData.enumProductDWithTransportationValue)
        
        // Then
        XCTAssertFalse(bool)
    }
    
    func testGivenAccessIsntGranted_WhenTellIfProductIsAFavorite_ThenFalse() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = false

        // When
        let bool = sut.productIsAFavorite(MockResponseData.enumProductA)
        
        // Then
        XCTAssertFalse(bool)
    }
    
    func testGivenAccessIsGrantedAndProductIsAFavorite_WhenGetCardType_ThenReturnFavoriteTypeCard() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        let cardType = sut.getCardType(for: MockResponseData.enumProductA)
        
        // Then
        XCTAssertEqual(cardType, .favoriteProduct(MockResponseData.enumProductA))
    }
    
    func testGivenAccessIsGrantedAndProductIsNotAFavorite_WhenGetCardType_ThenReturnProductTypeCard() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = true

        // When
        let cardType = sut.getCardType(for: MockResponseData.enumProductDWithTransportationValue)
        
        // Then
        XCTAssertEqual(cardType, .product(MockResponseData.enumProductDWithTransportationValue))
    }
    
    func testGivenAccessIsNotGrantedAndProductIsAFavorite_WhenGetCardType_ThenReturnProductTypeCard() {
        // Given
        let storageManger = MockStorageManager()
        storageManger.favoritesNUProducts = sampleNUProducts
        
        sut = FavoritesViewModel(storageManager: storageManger)
        sut.favoritesAreGranted = false

        // When
        let cardType = sut.getCardType(for: MockResponseData.enumProductA)
        
        // Then
        XCTAssertEqual(cardType, .product(MockResponseData.enumProductA))
    }
}












































