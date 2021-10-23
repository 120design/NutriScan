//
//  HistoryView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    
    var headerParagraphs: [String] {
        var array = ["Consultez ici *l’historique de vos trois dernières recherches* de produits."]
        if nuProVersion {
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
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
