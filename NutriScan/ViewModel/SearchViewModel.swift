//
//  SearchViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/08/2021.
//

import SwiftUI
import Combine

class SearchViewModel: ObservableObject {
    @Published var showCardDetail = false
    @Published var eanCode: String = ""

    @Published var foundProduct: NUProduct? {
        didSet {
            if let foundProduct = foundProduct {
                storageManager.create(product: foundProduct)
            }
        }
    }
    @Published var showResult = false
    @Published private(set) var currentlyResearching = false
    
    var clearButtonIsDisabled: Bool {
        eanCode.isEmpty
    }
    var searchButtonIsDisabled: Bool {
        eanCode.count != 8 && eanCode.count != 13
    }
    
    private let storageManager: StorageManagerProtocol
    
    private var subCancellable: AnyCancellable!
    private var validCharSet = CharacterSet(charactersIn: "0123456789")
    
    init(storageManager: StorageManagerProtocol = StorageManager.shared) {
        self.storageManager = storageManager
        
        subCancellable = $eanCode.sink { val in
            //check if the new string contains any invalid characters
            if val.rangeOfCharacter(from: self.validCharSet.inverted) != nil {
                //clean the string (do this on the main thread to avoid overlapping with the current ContentView update cycle)
                DispatchQueue.main.async {
                    self.eanCode = String(self.eanCode.unicodeScalars.filter {
                        self.validCharSet.contains($0)
                    })
                }
            } else if val.count > 13 {
                DispatchQueue.main.async {
                    self.eanCode = String(val.dropLast(val.count - 13))
                }
            }
        }
    }
    
    deinit {
        subCancellable.cancel()
    }
    
    func getProduct() {
        guard eanCode.count == 8 || eanCode.count == 13 else {
            return
        }
        
        currentlyResearching = true
        
        OFFService.shared.getProduct(from: eanCode) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let foundProduct):
                    self.foundProduct = foundProduct
                case .failure(let error):
                    // TODO: Traiter les erreurs
                    print("SearchManager ~> getProduct.failure ~> error ~>", error)
                    self.currentlyResearching = false
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
