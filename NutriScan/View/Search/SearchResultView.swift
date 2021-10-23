//
//  SearchResultView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @State var showCardDetail = false
    
    let products: [NUProduct]
        
    var body: some View {
        ProductsListView(
            navigationTitle: "Résultat",
            products: products,
            headerParagraphs: [
                "NutriScan a trouvé dans *la base de données d’Open Food Facts* ce produit correspondant *au code EAN \(searchViewModel.eanCode) :*"
            ]
        )
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(
            products: [NUProduct(
                id: "1234",
                name: "Moutarde de Dijon",
                imageURL: "",
                nutriments: Nutriments(
                    fiber_100g: 10,
                    carbohydrates_100g: 8.5,
                    proteins_100g: 8.5,
                    fat_100g: 4.2,
                    salt_100g: 25.12,
                    energy_kj_100g: 100,
                    energy_kcal_100g: 100
                ),
                nutriScore: nil,
                novaGroup: nil,
                ecoScore: nil
            )]
        )
    }
}
