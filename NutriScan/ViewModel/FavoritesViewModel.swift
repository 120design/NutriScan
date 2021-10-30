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
        if nuProVersion {
            products = storageManager.getFavoritesProducts()
        }
    }
    
    func addProductToFavorites(_ product: NUProduct) {
        if nuProVersion {
            storageManager.saveInFavorites(product: product)
            getFavoritesProducts()
        }
    }
    
    func removeProductFromFavorites(_ product: NUProduct) {
        if nuProVersion {
            storageManager.removeProductFromFavorites(product)
            getFavoritesProducts()
        }
    }
    
    func removeProductFromFavorites(indexSet: Foundation.IndexSet) {
        if nuProVersion {
            let index = indexSet[indexSet.startIndex]
            removeProductFromFavorites(products[index])
            getFavoritesProducts()
        }
    }
    
    func moveProduct(from: IndexSet, to: Int) {
        if nuProVersion {
            storageManager.moveFavoritesProduct(from: from, to: to)
            getFavoritesProducts()
        }
    }

    func productIsAFavorite(_ product: NUProduct) -> Bool {
        if nuProVersion {
            return products.contains { $0.id == product.id }
        } else {
            return false
        }
    }
    
    func getCardType(for product: NUProduct) -> CardView.CardType {
        if nuProVersion {
            return productIsAFavorite(product)
            ? .favoriteProduct(product)
            : .product(product)
        } else {
            return .product(product)
        }
    }
}
