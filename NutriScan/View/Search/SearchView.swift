//
//  SearchView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchManager = SearchManager()
    
    @State private var cardDetailType = CardView.CardType.scanButton
    
    let firstParagraph: some View =
        HStack {
            Text("Rercherchez un produit ")
                + Text("en scannant son code à barres")
                .font(nuBodyMediumItalicFont)
                + Text(" ou ")
                + Text("en tapant le numéro EAN")
                .font(nuBodyMediumItalicFont)
                + Text(" à huit ou treize chiffres inscrit sous son code à barres.")
        }
        .modifier(NUTextBodyModifier())
        .frame(maxWidth: .infinity)
        .padding([.top, .leading, .trailing])
    
    let secondaryParagraph: some View =
        HStack {
            Text("NutriScan interrogera alors ")
                + Text("la base de données d’Open Food Facts,")
                .font(nuBodyMediumItalicFont)
                + Text(" un projet citoyen à but non lucratif créé par des milliers de volontaires à travers le monde recensant ")
                + Text("plus de 700\u{00a0}000 produits.")
                .font(nuBodyMediumItalicFont)
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
//                    secondaryParagraph
                    
                    Button(action: {
                        cardDetailType = .scanButton
                        searchManager.showCardDetail = true
                    }, label: {
                        CardView(
                            cardType: .scanButton
                        )
                    })
                    .opacity(
                        cardDetailType == .scanButton
                            && searchManager.showCardDetail
                            ? 0
                            : 1
                    )
                   .offset(
                        x: 0,
                        y: cardDetailType == .scanButton
                            && searchManager.showCardDetail
                            ? 300
                            : 0
                    )
                    
                    Text("ou")
                        .padding(.top, -10.0)
                        .padding(.bottom, -5.0)
                        .modifier(NUStrongLabelModifier())
                    
                    Button(action: {
                        cardDetailType = .eanButton
                        searchManager.showCardDetail = true
                    }, label: {
                        CardView(
                            cardType: .eanButton
                        )
                    })
                    .opacity(
                        cardDetailType == .eanButton
                            && searchManager.showCardDetail
                            ? 0
                            : 1
                    )
                    .offset(
                        x: 0,
                        y: cardDetailType == .eanButton
                            && searchManager.showCardDetail
                            ? 300
                            : 0
                    )
                    .animation(.spring())
                    
                    NavigationLink(
                        destination: SearchResultView(),
                        isActive: $searchManager.showResult,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationTitle("Recherche")
            .foregroundColor(.nuSecondaryColor)
            .fullScreenCover(isPresented: $searchManager.showCardDetail) {
                CardDetailView(
                    showDetail: $searchManager.showCardDetail,
                    cardType: cardDetailType
                )
                .background(NUBackgroundClearView())
                .environmentObject(searchManager)
            }
        }
        .nuNavigationBar()
        .environmentObject(searchManager)
    }
}

struct SearchView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        SearchView()
            .previewDevice("iPhone SE (1st generation)")
    }
}
