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
    
    var isSelected: Bool
    
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
//                .onAppear {
//                    print("HistoryView ~> ON APPEAR")
//                    historyViewModel.getHistoryProducts()
//                }
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
        .onChange(of: isSelected) { isSelected in
            if isSelected {
                historyViewModel.getHistoryProducts()
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(isSelected: true)
    }
}
