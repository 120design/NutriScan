//
//  HistoryView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    @EnvironmentObject private var inAppPurchasesViewModel: InAppPurchasesViewModel
    
    var headerParagraphs: [String] {
        var array = ["Consultez ici *l’historique de vos \(historyViewModel.maxHistory.rawValue) dernières recherches* de produits."]
        if inAppPurchasesViewModel.paidVersionIsPurchased ?? false && !historyViewModel.products.isEmpty {
            array.append("Vous pouvez *ajouter un produit à vos favoris* ou l’en supprimer *en le faisant glisser vers la gauche* pour faire apparaître le bouton prévu à cet effet.")
        }
        return array
    }
            
    var body: some View {
        NavigationView {
            ProductsListView(
                navigationTitle: "Historique",
                products: historyViewModel.products,
                headerParagraphs: headerParagraphs
            )
                .onAppear {
                    historyViewModel.getHistoryProducts()
                }
        }
        .nuNavigationBar()
        .environmentObject(historyViewModel)
        .onReceive(inAppPurchasesViewModel.$paidVersionIsPurchased) { paidVersionIsPurchased in
            guard let paidVersionIsPurchased = paidVersionIsPurchased
            else {
                historyViewModel.maxHistory = .low
                return
            }
            
            historyViewModel.maxHistory = paidVersionIsPurchased ? .high : .low
        }
//        
//        .onReceive(inAppPurchasesViewModel.$paidVersionIsPurchased) { paidVersionIsPurchased in
//            guard let paidVersionIsPurchased = paidVersionIsPurchased
//            else {
//                storageManager.maxHistory = HistoryViewModel.MaxHistory.low.int
//                return
//            }
//            
//            storageManager.maxHistory = paidVersionIsPurchased ? HistoryViewModel.MaxHistory.high.int : HistoryViewModel.MaxHistory.low.int
//        }
//
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
