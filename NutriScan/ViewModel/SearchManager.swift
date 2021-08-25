//
//  SearchManager.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/08/2021.
//

import SwiftUI

class SearchManager: ObservableObject {
    @Published var eanCode = "3229820108605"
    @Published var foundProduct: NUProduct?
    @Published var showResult = false
    @Published private(set) var currentlyResearching = false
    
    func getProduct(from eanCode: String) {
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
                case .failure(_):
                    // TODO: Traiter les erreurs
                    print("SearchManager ~> getProduct.failure")
                }
                
                self.showResult = true
                self.currentlyResearching = false
            }
        }
    }
    
    // Annuler la recherche quand on ferme la CardDetailView avant d’avoir reçu la réponse d’OFF
    func cancelRequest() {
        
    }
}
