//
//  FavoritesViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 09/10/2021.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published var products: [NUProduct] = []
    
    private let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol = StorageManager.shared) {
        self.storageManager = storageManager
        getFavoritesProducts()
    }
    
    func getFavoritesProducts() {
        products = storageManager.getFavoritesProducts()
    }
    
    func addProductToFavorites(_ product: NUProduct) {
        storageManager.saveInFavorites(product: product)
        getFavoritesProducts()
    }
    
    func removeProductFromFavorites(_ product: NUProduct) {
        storageManager.removeProductFromFavorites(product)
        getFavoritesProducts()
    }
    
    func removeProductFromFavorites(indexSet: Foundation.IndexSet) {
        let index = indexSet[indexSet.startIndex]
        removeProductFromFavorites(products[index])
        getFavoritesProducts()
    }
    
    func moveProduct(from: IndexSet, to: Int) {
        storageManager.moveFavoritesProduct(from: from, to: to)
        getFavoritesProducts()
    }

    func productIsAFavorite(_ product: NUProduct) -> Bool {
        products.contains { $0.id == product.id }
    }
    
    func getCardType(for product: NUProduct) -> CardView.CardType {
        productIsAFavorite(product)
        ? .favoriteProduct(product)
        : .product(product)
    }
}
