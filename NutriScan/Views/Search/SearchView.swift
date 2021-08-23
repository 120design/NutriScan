//
//  SearchView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var cardDetailManager: CardDetailManager
    
    @Namespace private var eanNamespace
    @Namespace private var scanNamespace
    
    @State var goToResult = false
    @State var eanCode = "3229820108605"
    @State var showDetail = false
    
    @ViewBuilder
    private var eanCardView: some View {
        CardView(
            namespace: eanNamespace,
            cardType: .eanButton
        )
    }
    
    @ViewBuilder
    private var cardDetailView: some View {
        CardDetailView(
            namespace: eanNamespace,
            cardType: .eanButton
        )
    }
    
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
                        cardDetailManager
                            .setCardDetailView(
                                namespace: scanNamespace,
                                cardType: .scanButton
                            )
                    }, label: {
                        CardView(
                            namespace: scanNamespace,
                            cardType: .scanButton
                        )
                    })
                    .opacity(
                        cardDetailManager
                            .cardDetailView?
                            .cardType == .scanButton
                            ? 0
                            : 1
                    )
                    
                    Text("ou")
                        .padding(.top, -10.0)
                        .padding(.bottom, -5.0)
                        .modifier(NUStrongLabelModifier())
                    
                    Button(action: {
                        cardDetailManager
                            .setCardDetailView(
                                namespace: eanNamespace,
                                cardType: .eanButton
                            )
                    }, label: {
                        eanCardView
                    })
                    .opacity(
                        cardDetailManager
                            .cardDetailView?
                            .cardType == .eanButton
                            ? 0
                            : 1
                    )
                    
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
//        .overlay(
//            Group {
//                if showScanDetail {
//                    CardDetailView(
//                        showDetail: $showScanDetail,
//                        eanCode: $eanCode,
//                        goToResult: $goToResult,
//                        namespace: scanNamespace,
//                        cardType: .scanButton
//                    )
//                }
//                if showEanDetail {
//                    CardDetailView(
//                        showDetail: $showEanDetail,
//                        eanCode: $eanCode,
//                        goToResult: $goToResult,
//                        namespace: eanNamespace,
//                        cardType: .eanButton
//                    )
//                }
//            }
//            .padding(.top)
//            .ignoresSafeArea()
//        )
    }
}

struct SearchView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        SearchView()
            .previewDevice("iPhone SE (1st generation)")
    }
}
