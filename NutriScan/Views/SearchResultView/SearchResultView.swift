//
//  SearchResultView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchResultView: View {
    @State var product: NSProduct?

    let eanCode: String?

    var body: some View {
        NavigationView {
                    
            
            List {
                if let product = product {
                    Text("Nom du produit : \(product.name)")
                    Text("Code EAN : \(product.id)")
                }
            }
            .navigationTitle("Résultat")
            .onAppear(perform: getProduct)
        }
    }

    private func getProduct() {
        guard let eanCode = eanCode else {
            print("PAS DE CODE EAN !")
            return
        }
        OFFService.shared.getProduct(from: eanCode) { (error, product) in
            if let error = error {
                print("ERROR :", error)
            }
            guard let product = product else {
                print("PRODUCT ERROR")
                return
            }
            self.product = product
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(eanCode: "lol")
    }
}
