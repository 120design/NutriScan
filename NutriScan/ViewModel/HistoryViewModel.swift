//
//  HistoryViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 09/10/2021.
//

import SwiftUI

class HistoryViewModel: ObservableObject {
    @Published var products: [NUProduct] = []
    @Published var maxHistory: MaxHistory = .low {
        didSet {
            storageManager.maxHistory = maxHistory.int
        }
    }
    
    enum MaxHistory: String {
        case low = "trois",
             high = "dix"
        
        var int: Int {
            switch self {
            case .low:
                return 3
            case .high:
                return 10
            }
        }
    }
    
    private var storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol = StorageManager.shared) {
        self.storageManager = storageManager
    }
    
    func getHistoryProducts() {
        products = storageManager.getHistoryProducts()
    }
}
