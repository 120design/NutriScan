//
//  HistoryViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 09/10/2021.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var products: [NUProduct] = []
    @Published var maxHistory: MaxHistory = .three
    
    enum MaxHistory: String {
        case three = "trois", ten = "dix"
        
        var int: Int {
            switch self {
            case .three:
                return 3
            case .ten:
                return 10
            }
        }
    }
    
    private let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol = StorageManager.shared) {
        self.storageManager = storageManager
    }
    
    func getHistoryProducts() {
        products = storageManager.getHistoryProducts()
    }
}
