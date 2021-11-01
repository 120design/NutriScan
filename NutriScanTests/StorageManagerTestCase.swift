//
//  StorageManagerTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 31/10/2021.
//

import XCTest
import CoreData

@testable
import NutriScan

class StorageManagerTestCase: XCTestCase {
    var sut = StorageManager(.inMemory)
    
    override func setUp() {
        super.setUp()
        
        sut = StorageManager(.inMemory)
    }
    
    // MARK: Create product
        
    func testGivenProductStored_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.correctFoundProduct)
        
        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertEqual(
            query,
            [MockResponseData.correctFoundProduct]
        )
    }
    
    func testGivenProductStoredWithNilNutriScoreGrade_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", MockResponseData.enumProductA.id)
        request.fetchLimit = 1

        let cdProduct = try? sut.persistentContainer.viewContext.fetch(request).first

        cdProduct?.nutriScore?.grade = nil

        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertNil(query[0].nutriScore!.grade)
    }
    
    func testGivenProductStoredWithNilEcoScoreGrade_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", MockResponseData.enumProductA.id)
        request.fetchLimit = 1

        let cdProduct = try? sut.persistentContainer.viewContext.fetch(request).first

        cdProduct?.ecoScore?.grade = nil
        cdProduct?.ecoScore?.grade_fr = nil

        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertNil(query[0].ecoScore!.grade)
        XCTAssertNil(query[0].ecoScore!.grade_fr)
    }
    
    func testGivenProductStoredWithNilProductionSystemAndNilOriginsOfIngredients_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", MockResponseData.enumProductA.id)
        request.fetchLimit = 1

        let cdProduct = try? sut.persistentContainer.viewContext.fetch(request).first

        cdProduct?.ecoScore?.adjustments?.production_system = nil
        cdProduct?.ecoScore?.adjustments?.origins_of_ingredients = nil

        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertNil(query[0].ecoScore!.adjustments!.production_system!.value)
        XCTAssertNil(query[0].ecoScore!.adjustments!.origins_of_ingredients!.transportation_value)
        XCTAssertNil(query[0].ecoScore!.adjustments!.origins_of_ingredients!.transportation_values)
        XCTAssertNil(query[0].ecoScore!.adjustments!.origins_of_ingredients!.epi_value)
    }
    
    func testGivenProductStoredWithNilPackaging_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", MockResponseData.enumProductA.id)
        request.fetchLimit = 1

        let cdProduct = try? sut.persistentContainer.viewContext.fetch(request).first

        cdProduct?.ecoScore?.adjustments?.packaging = nil
        cdProduct?.ecoScore?.adjustments?.threatened_species = nil

        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertNil(query[0].ecoScore!.adjustments!.packaging!.value)
        XCTAssertNil(query[0].ecoScore!.adjustments!.threatened_species!.value)
    }
    
    func testGivenProductStoredWithNilAdjustments_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", MockResponseData.enumProductA.id)
        request.fetchLimit = 1

        let cdProduct = try? sut.persistentContainer.viewContext.fetch(request).first

        cdProduct?.ecoScore?.adjustments = nil

        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertNil(query[0].ecoScore!.adjustments)
    }

    func testGivenEmptyProductStored_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.create(product: MockResponseData.emptyProduct)
        
        // When
        let query = sut.getHistoryProducts()
        
        // Then
        XCTAssertEqual(query, [MockResponseData.emptyProduct])
    }

    func testGivenProductWihtAEnumsStored_WhenGetProductData_ThenReturnCorrectData() {
        // Given
        sut.maxHistory = 10
        
        sut.create(product: MockResponseData.enumProductA)
        sut.create(product: MockResponseData.enumProductB)
        sut.create(product: MockResponseData.enumProductC)
        sut.create(product: MockResponseData.enumProductDWithTransportationValue)
        sut.create(product: MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues)

        // When
        let query = sut.getHistoryProducts()

        // Then
        XCTAssertEqual(
            query,
            [
                MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues,
                MockResponseData.enumProductDWithTransportationValue,
                MockResponseData.enumProductC,
                MockResponseData.enumProductB,
                MockResponseData.enumProductA
            ]
        )
    }
    
    // MARK: History
    
    func testGivenOverMaxHistory_WhenGetHistory_ThenReturnMaxHistoryData() {
        // Given
        sut.maxHistory = 3
        
        sut.create(product: MockResponseData.enumProductA)
        sut.create(product: MockResponseData.enumProductB)
        sut.create(product: MockResponseData.enumProductC)
        sut.create(product: MockResponseData.enumProductDWithTransportationValue)
        sut.create(product: MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues)

        // When
        let query = sut.getHistoryProducts()

        // Then
        XCTAssertEqual(
            query,
            [
                MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues,
                MockResponseData.enumProductDWithTransportationValue,
                MockResponseData.enumProductC,
            ]
        )
    }
    
    func testGivenHistoryContainProductWithoutIDAndOverMaxHistory_WhenGetHistory_ThenDontReturnProduct() {
        // Given
        sut.maxHistory = 3
        
        let cdProduct = CDProduct(context: sut.persistentContainer.viewContext)
        cdProduct.name = "fake"
        
        let cdHistory = CDHistory(context: sut.persistentContainer.viewContext)
        
        cdHistory.products = [cdProduct]
        
        try! sut.persistentContainer.viewContext.save()

        sut.create(product: MockResponseData.enumProductA)
        sut.create(product: MockResponseData.enumProductB)
        sut.create(product: MockResponseData.enumProductC)
        sut.create(product: MockResponseData.enumProductDWithTransportationValue)
        sut.create(product: MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues)

        // When
        let query = sut.getHistoryProducts()

        // Then
        XCTAssertEqual(
            query,
            [
                MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues,
                MockResponseData.enumProductDWithTransportationValue,
                MockResponseData.enumProductC,
            ]
        )
    }
    
    func testGivenHistoryContainProductWithoutID_WhenGetHistory_ThenDontReturnProduct() {
        // Given
        let cdProduct = CDProduct(context: sut.persistentContainer.viewContext)
        cdProduct.name = "fake"
        
        let cdHistory = CDHistory(context: sut.persistentContainer.viewContext)
        
        cdHistory.products = [cdProduct]
        
        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivenEmptyProducts_WhenGetHistoryProducts_ThenEmptyResult() {
        // Given

        // When
        let query = sut.getHistoryProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testRemovedFavoritesProductIfEmptyHistory_WhenGetHistoryProducts_ThenEmptyResult() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        let request: NSFetchRequest<CDHistory> = CDHistory.fetchRequest()
        let cdHistory = try? sut.persistentContainer.viewContext.fetch(request).first

        sut.persistentContainer.viewContext.delete(cdHistory!)
        
        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getHistoryProducts()
        
        sut.removeProductFromFavorites(MockResponseData.enumProductA)

        // Then
        XCTAssertEqual(query, [])
    }

    // MARK: Favorites

    func testGivenProductUnrecordedIsSavedInFavorites_WhenGetFavorites_ThenEmptyResult() {
        // Given
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivenSaveOneProductInFavorites_WhenGetFavorites_ThenCorrectResult() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [MockResponseData.enumProductA])
    }
    
    func testGivenSaveTwoProductInFavorites_WhenGetFavorites_ThenCorrectResult() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        sut.create(product: MockResponseData.enumProductB)
        sut.saveInFavorites(product: MockResponseData.enumProductB)

        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [MockResponseData.enumProductB, MockResponseData.enumProductA])
    }
    
    func testGivenEmptyProducts_WhenGetFavoritessProducts_ThenEmptyResult() {
        // Given

        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivenEmptyProducts_WhenTellIfProductIsAFavorite_ThenEmptyResult() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)

        // When
        let query = sut.productIsAFavorite(MockResponseData.enumProductA)

        // Then
        XCTAssertTrue(query)
    }
    
    func testGivenSaveProductWithoutNameInFavorites_WhenGetFavorites_ThenResultDontContainProduct() {
        // Given
        let cdProduct = CDProduct(context: sut.persistentContainer.viewContext)
        cdProduct.id = "123"
        
        let cdFavorites = CDFavorites(context: sut.persistentContainer.viewContext)
        
        cdFavorites.products = [cdProduct]
        
        try! sut.persistentContainer.viewContext.save()

        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivenRecordProductAlreadyPresentInFavorites_WhenGetFavoritesProducts_ThenProductIsAlwaysInFavorites() {
        // Given
        sut.maxHistory = 3

        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        sut.create(product: MockResponseData.enumProductB)
        sut.create(product: MockResponseData.enumProductC)
        sut.create(product: MockResponseData.enumProductDWithTransportationValue)
        sut.create(product: MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues)

        sut.create(product: MockResponseData.enumProductA)

        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [
            MockResponseData.enumProductA
        ])
    }
    
    func testGivenRecordProductAlreadyPresentInFavoritesWithAnotherProduct_WhenGetFavoritesProducts_ThenProductIsAlwaysInFavorites() {
        // Given
        sut.maxHistory = 3

        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        sut.create(product: MockResponseData.enumProductB)
        sut.saveInFavorites(product: MockResponseData.enumProductB)
        
        sut.create(product: MockResponseData.enumProductC)
        sut.create(product: MockResponseData.enumProductDWithTransportationValue)
        sut.create(product: MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues)

        sut.create(product: MockResponseData.enumProductA)

        // When
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [
            MockResponseData.enumProductA,
            MockResponseData.enumProductB
        ])
    }
    
    func testGivenNotRecordedProductSavedNameInFavorites_WhenRemoveProductFromFavorites_ThenResultDontContainProduct() {
        // Given
        sut.saveInFavorites(product: MockResponseData.enumProductA)

        // When
        sut.removeProductFromFavorites(MockResponseData.enumProductA)
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivendProductSavedNameInFavorites_WhenRemoveProductFromFavorites_ThenResultDontContainProduct() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductA)

        // When
        sut.removeProductFromFavorites(MockResponseData.enumProductA)
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivendProductNotSavedNameInFavorites_WhenRemoveProductFromFavorites_ThenResultDontContainProduct() {
        // Given
        sut.create(product: MockResponseData.enumProductA)

        // When
        sut.removeProductFromFavorites(MockResponseData.enumProductA)
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivenEmptyHistory_WhenRemoveProductFromFavorites_ThenResultDontContainProduct() {
        // Given
        let cdProduct = CDProduct(context: sut.persistentContainer.viewContext)
        cdProduct.id = "A"
                
        try! sut.persistentContainer.viewContext.save()

        // When
        sut.removeProductFromFavorites(MockResponseData.enumProductA)
        let query = sut.getFavoritesProducts()

        // Then
        XCTAssertEqual(query, [])
    }
    
    func testGivenFavoritesProductIsNotInHistory_WhenRemoveProductFromFavorites_ThenProductDeleted() {
        // Given
        sut.maxHistory = 3
        
        sut.create(product: MockResponseData.enumProductA)
        
        sut.saveInFavorites(product: MockResponseData.enumProductA)
        
        sut.create(product: MockResponseData.enumProductB)
        sut.create(product: MockResponseData.enumProductC)
        sut.create(product: MockResponseData.enumProductDWithTransportationValue)
        sut.create(product: MockResponseData.enumProductEWithNilTransportationValueAndNilTransportationValues)

        // When
        sut.removeProductFromFavorites(MockResponseData.enumProductA)

        // Then
        let request: NSFetchRequest<CDProduct> = CDProduct.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", MockResponseData.enumProductA.id)
        request.fetchLimit = 1

        let cdProduct = try? sut.persistentContainer.viewContext.fetch(request).first
        
        XCTAssertNil(cdProduct)
    }

    
    func testGivenEmptyFavorites_WhenMoveFavoritesProduct_ThenEmptyFavorites() {
        // Given

        // When
        sut.moveFavoritesProduct(from: IndexSet(integer: 0), to: 1)

        // Then
        let query = sut.getFavoritesProducts()
        XCTAssertEqual(query, [])
    }
    
    func testGivenMoveUpFavoriteProduct_WhenMoveFavoritesProduct_ThenProductMoved() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.create(product: MockResponseData.enumProductB)

        sut.saveInFavorites(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductB)

        // When
        sut.moveFavoritesProduct(from: IndexSet(integer: 1), to: 0)

        // Then
        let query = sut.getFavoritesProducts()
        XCTAssertEqual(query, [
            MockResponseData.enumProductA,
            MockResponseData.enumProductB
        ])
    }
    
    func testGivenMoveDownFavoriteProduct_WhenMoveFavoritesProduct_ThenProductMoved() {
        // Given
        sut.create(product: MockResponseData.enumProductA)
        sut.create(product: MockResponseData.enumProductB)

        sut.saveInFavorites(product: MockResponseData.enumProductA)
        sut.saveInFavorites(product: MockResponseData.enumProductB)

        // When
        sut.moveFavoritesProduct(from: IndexSet(integer: 0), to: 1)
        
        // Then
        let query = sut.getFavoritesProducts()
        XCTAssertEqual(query, [
            MockResponseData.enumProductB,
            MockResponseData.enumProductA,
        ])
    }
}
