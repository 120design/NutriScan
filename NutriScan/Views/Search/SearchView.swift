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
                Text("Rercherchez un produit en scannant son code à barres ou en tapant le numéro EAN à treize chiffres inscrit sous son code à barres.")
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
