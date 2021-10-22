//
//  HistoryViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 09/10/2021.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var products: [NUProduct] = []
    
    private let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol = StorageManager.shared) {
        self.storageManager = storageManager
    }
    
    func getHistoryProducts() {
        products = storageManager.getHistoryProducts()
    }
}
