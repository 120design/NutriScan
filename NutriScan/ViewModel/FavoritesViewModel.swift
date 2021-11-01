//
//  FavoritesViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 09/10/2021.
//

import SwiftUI

class FavoritesViewModel: ObservableObject {
    @Published internal var products: [NUProduct] = []
    @Published var favoritesAreGranted: Bool = false
    
    private let storageManager: StorageManagerProtocol
    
    init(
        storageManager: StorageManagerProtocol = StorageManager.shared
    ) {
        self.storageManager = storageManager
        getFavoritesProducts()
    }
    
    func getFavoritesProducts() {
        if favoritesAreGranted {
            products = storageManager.getFavoritesProducts()
        }
    }
    
    func addProductToFavorites(_ product: NUProduct) {
        if favoritesAreGranted {
            storageManager.saveInFavorites(product: product)
            getFavoritesProducts()
        }
    }
    
    func removeProductFromFavorites(_ product: NUProduct) {
        if favoritesAreGranted {
            storageManager.removeProductFromFavorites(product)
            getFavoritesProducts()
        }
    }
    
    func removeProductFromFavorites(indexSet: Foundation.IndexSet) {
        if favoritesAreGranted {
            let index = indexSet[indexSet.startIndex]
            removeProductFromFavorites(products[index])
            getFavoritesProducts()
        }
    }
    
    func moveProduct(from: IndexSet, to: Int) {
        if favoritesAreGranted {
            storageManager.moveFavoritesProduct(from: from, to: to)
            getFavoritesProducts()
        }
    }

    func productIsAFavorite(_ product: NUProduct) -> Bool {
        if favoritesAreGranted {
            return products.contains { $0.id == product.id }
        } else {
            return false
        }
    }
    
    func getCardType(for product: NUProduct) -> CardView.CardType {
        if favoritesAreGranted {
            return productIsAFavorite(product)
            ? .favoriteProduct(product)
            : .product(product)
        } else {
            return .product(product)
        }
    }
}
