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
    
    @Published var alertViewModel = AlertViewModel()
    
    private let connectionAlertTitle = "Problème de connexion"
    private let connectionAlertMessage = "Votre appareil n’est pas connecté au web, merci de vérifier votre connexion avant de lancer une recherche."

    private let noProductFoundAlertTitle = "Pas de produit trouvé"
    private var noProductFoundAlertMessage: String {
        "Aucun produit correspondant au code EAN \(eanCode) n’a été trouvé dans la base de données d’Open Food Facts. Il pourrait être ajouté ultérieurement, alors n’hésitez pas à ré-essayer une autre fois."
    }
    
    private let undefinedAlertTitle = "Erreur indéterminée"
    private let undefinedAlertMessage = "Une erreur est survenue, merci de ré-essayer ultérieurement."
    
    var clearButtonIsDisabled: Bool {
        eanCode.isEmpty
    }
    var searchButtonIsDisabled: Bool {
        eanCode.count != 8 && eanCode.count != 13
    }
    
    private let storageManager: StorageManagerProtocol
    private let offService: OFFServiceProtocol

    private var subCancellable: AnyCancellable!
    private var validCharSet = CharacterSet(charactersIn: "0123456789")
    
    init(
        storageManager: StorageManagerProtocol = StorageManager.shared,
        offService: OFFServiceProtocol = OFFService()
    ) {
        self.storageManager = storageManager
        self.offService = offService
        
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
        
        offService.getProduct(from: eanCode) { result in
            DispatchQueue.main.async {
                self.currentlyResearching = false

                switch result {
                case .success(let foundProduct):
                    self.foundProduct = foundProduct
                    self.showCardDetail = false
                    self.showResult = true
                    return

                case .failure(let error):
                    print("SearchManager ~> getProduct.failure ~> error ~>", error)
                    self.alertViewModel.isPresented = true

                    switch error {
                    case .connection:
                        self.alertViewModel.title = self.connectionAlertTitle
                        self.alertViewModel.message = self.connectionAlertMessage

                        
                    case .noProductFound:
                        self.alertViewModel.title = self.noProductFoundAlertTitle
                        self.alertViewModel.message = self.noProductFoundAlertMessage
                        
                    case .undefined,
                            .response,
                            .statusCode,
                            .data:
                        self.alertViewModel.title = self.undefinedAlertTitle
                        self.alertViewModel.message = self.undefinedAlertMessage
                        
                    case .cancelledRequest:
                        self.alertViewModel.isPresented = false
                        self.showCardDetail = false
                    }
                    return
                }
            }
        }
    }
    
    // Cancel the search when closing the CardDetailView before receiving the response from API
    func cancelRequest() {
        offService.cancelRequest(with: eanCode)
    }
}
