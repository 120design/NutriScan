//
//  SearchManager.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/08/2021.
//

import SwiftUI

class SearchManager: ObservableObject {
    @Published var showCardDetail = false
    @Published var eanCode = "7613035239562"
    @Published var foundProduct: NUProduct? {
        didSet {
            if let foundProduct = foundProduct {
                storageManager.create(product: foundProduct)
            }
        }
    }
    @Published var showResult = false
    @Published private(set) var currentlyResearching = false
        
    private let storageManager: StorageManagerProtocol
    
    init(storageManager: StorageManagerProtocol = StorageManager.shared) {
        self.storageManager = storageManager
    }
    
    func getProduct() {
        // Reprise de la View à intégrer ici
        //        guard eanCode.count == 8 || eanCode.count == 13 else {
        //            return
        //        }
        //        eanCode = eanCode
        //        goToResult = true
        //        showDetail = false

        currentlyResearching = true
        
        OFFService.shared.getProduct(from: eanCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let foundProduct):
                    self.foundProduct = foundProduct
                case .failure(let error):
                    // TODO: Traiter les erreurs
                    print("SearchManager ~> getProduct.failure ~> error ~>", error)
                    return
                }

                self.showCardDetail = false
                self.showResult = true
                self.currentlyResearching = false
            }
        }
    }
    
    // Annuler la recherche quand on ferme la CardDetailView avant d’avoir reçu la réponse d’OFF
    func cancelRequest() {
        OFFService.shared.cancelRequest(with: eanCode)
    }
}
