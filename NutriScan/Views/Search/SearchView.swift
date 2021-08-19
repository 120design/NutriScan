//
//  SearchView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchView: View {
    @State private var eanCode = "3229820108605"
    @State private var goToResult = false
    
    @Namespace private var eanNamespace
    @Namespace private var scanNamespace
    
    @State var showEanDetail = false
    @State var showScanDetail = false
    
    let firstParagraph: some View =
        HStack {
            Text("Rercherchez un produit ")
                + Text("en scannant son code à barres")
                .font(NUBodyTextEmphasisFont)
                + Text(" ou ")
                + Text("en tapant le numéro EAN")
                .font(NUBodyTextEmphasisFont)
                + Text(" à huit ou treize chiffres inscrit sous son code à barres.")
        }
        .modifier(NUTextBodyModifier())
        .frame(maxWidth: .infinity)
        .padding([.top, .leading, .trailing])
    
    let secondaryParagraph: some View =
        HStack {
            Text("NutriScan interrogera alors ")
                + Text("la base de données d’Open Food Facts,")
                .font(NUBodyTextEmphasisFont)
                + Text(" un projet citoyen à but non lucratif créé par des milliers de volontaires à travers le monde recensant ")
                + Text("plus de 700\u{00a0}000 produits.")
                .font(NUBodyTextEmphasisFont)
        }
        .modifier(NUTextBodyModifier())
        .frame(maxWidth: .infinity)
        .padding([.leading, .trailing])
        .padding(.top, 8)
    
    var body: some View {
        NavigationView {
            ZStack {
                NUBackgroundView()
                ScrollView {
                    firstParagraph
                    secondaryParagraph
                    
                    Button(action: {
                        self.showScanDetail = true
                    }, label: {
                        CardView(
                            namespace: scanNamespace,
                            cardType: .scanButton
                        )
                    })
                    
                    Text("ou")
                        .padding(.top, -10.0)
                        .padding(.bottom, -5.0)
                        .modifier(NUStrongLabelModifier())
                    
                    Button(action: {
                        self.showEanDetail = true
                    }, label: {
                        CardView(
                            namespace: eanNamespace,
                            cardType: .eanButton
                        )
                    })
                    
                    NavigationLink(
                        destination: SearchResultView(eanCode: eanCode),
                        isActive: $goToResult,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationTitle("Recherche")
            .foregroundColor(.nuSecondaryColor)
        }
        .nuNavigationBar()
        .overlay(
            Group {
                if showScanDetail {
                    CardDetailView(
                        showDetail: $showScanDetail,
                        eanCode: $eanCode,
                        goToResult: $goToResult,
                        namespace: scanNamespace,
                        cardType: .scanButton
                    )
                } else if showEanDetail {
                    CardDetailView(
                        showDetail: $showEanDetail,
                        eanCode: $eanCode,
                        goToResult: $goToResult,
                        namespace: eanNamespace,
                        cardType: .eanButton
                    )
                }
            }
            .padding(.top)
            .ignoresSafeArea()
        )
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .previewDevice("iPhone 8")
        SearchView()
            .previewDevice("iPhone SE (1st generation)")
    }
}
