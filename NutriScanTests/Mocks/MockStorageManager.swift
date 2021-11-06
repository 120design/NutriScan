//
//  MockStorageManager.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 02/11/2021.
//

import Foundation
@testable import NutriScan

class MockStorageManager: StorageManagerProtocol {
    var maxHistory: Int = HistoryViewModel.MaxHistory.low.int
    
    var nuProducts = [NUProduct]()
    var historyNUProducts = [NUProduct]()
    var favoritesNUProducts = [NUProduct]()
    
    func create(product nuProduct: NUProduct) {}
    
    func getHistoryProducts() -> [NUProduct] {
        historyNUProducts
    }
    
    func getFavoritesProducts() -> [NUProduct] {
        favoritesNUProducts
    }
    
    func productIsAFavorite(_ product: NUProduct) -> Bool {
        favoritesNUProducts.contains(product)
    }
    
    func saveInFavorites(product nuProduct: NUProduct) {
        favoritesNUProducts = [nuProduct] + favoritesNUProducts
    }
    
    func removeProductFromFavorites(_ nuProduct: NUProduct) {
        favoritesNUProducts = favoritesNUProducts.filter { $0.id != nuProduct.id }
    }
    
    func moveFavoritesProduct(from: IndexSet, to: Int) {
        favoritesNUProducts.move(fromOffsets: from, toOffset: to)
    }
}
