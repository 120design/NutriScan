//
//  HistoryView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    
    var body: some View {
        NavigationView {
//            ScrollView {
//                LazyVStack {
//                    Text("Consultez ici l’historique de vos dix dernières recherches de produits. Pour sauvegarder plus de produits, ajoutez-les à vos favoris !")
//                }
//            }
            List(historyViewModel.products, id: \.id) { product in
                Text(product.name)
            }
            .navigationTitle("Historique")
            .padding()
            .onAppear {
                historyViewModel.getAllProducts()
            }
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
