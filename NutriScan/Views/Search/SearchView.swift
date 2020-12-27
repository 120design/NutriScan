//
//  SearchView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchView: View {
    @State private var scanViewIsShowing = false
    @State private var eanCode: String?
    @State private var goToResult = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Rercherchez un produit en scannant son code à barres ou en tapant le numéro EAN à huit ou treize chiffres inscrit sous son code à barres.")
                    .padding(.bottom)
                Text("NutriScan interrogera alors la base de données d’Open Food Facts, un projet citoyen à but non lucratif créé par des milliers de volontaires à travers le monde recensant plus de 700 000 produits à travers le monde.")
                    .padding(.bottom)

                Spacer()
                if let eanCode = eanCode {
                    Text("Code EAN : \(eanCode)")
                }
                Button(action: {
                    self.scanViewIsShowing = true
                }, label: {
                    Text("Scanner un code à barres")
                })
                Text("ou")
                NavigationLink(
                    destination: Text("Taper un code"),
                    label: {
                        Text("Taper un code EAN13")
                    }
                )
                NavigationLink(
                    destination: SearchResultView(eanCode: eanCode),
                    isActive: $goToResult,
                    label: {
                        EmptyView()
                    }
                )
                Spacer()
            }
            .navigationTitle("Recherche")
            .sheet(isPresented: $scanViewIsShowing, content: {
                ScanSheetView(
                    eanCode: $eanCode,
                    isShowing: $scanViewIsShowing,
                    goToResult: $goToResult
                )
            })
            .padding()
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
