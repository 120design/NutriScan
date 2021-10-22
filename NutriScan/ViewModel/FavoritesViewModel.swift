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
    }
    
    func getFavoritesProducts() {
        products = storageManager.getFavoritesProducts()
    }
    
    func removeProductFromFavorites(_ product: NUProduct) {
        
    }
}
