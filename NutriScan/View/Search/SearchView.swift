//
//  SearchView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var searchViewModel = SearchViewModel()
    
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
                        searchViewModel.showCardDetail = true
                    }, label: {
                        CardView(
                            cardType: .scanButton
                        )
                    })
                    .opacity(
                        cardDetailType == .scanButton
                            && searchViewModel.showCardDetail
                            ? 0
                            : 1
                    )
                   .offset(
                        x: 0,
                        y: cardDetailType == .scanButton
                            && searchViewModel.showCardDetail
                            ? 300
                            : 0
                    )
                    
                    Text("ou")
                        .padding(.top, -10.0)
                        .padding(.bottom, -5.0)
                        .modifier(NUStrongLabelModifier())
                    
                    Button(action: {
                        cardDetailType = .eanButton
                        searchViewModel.showCardDetail = true
                    }, label: {
                        CardView(
                            cardType: .eanButton
                        )
                    })
                    .opacity(
                        cardDetailType == .eanButton
                            && searchViewModel.showCardDetail
                            ? 0
                            : 1
                    )
                    .offset(
                        x: 0,
                        y: cardDetailType == .eanButton
                            && searchViewModel.showCardDetail
                            ? 300
                            : 0
                    )
                    .animation(.spring())
                    
                    NavigationLink(
                        destination: SearchResultView(),
                        isActive: $searchViewModel.showResult,
                        label: {
                            EmptyView()
                        }
                    )
                }
            }
            .navigationTitle("Recherche")
            .foregroundColor(.nuSecondaryColor)
            .fullScreenCover(isPresented: $searchViewModel.showCardDetail) {
                CardDetailView(
                    showDetail: $searchViewModel.showCardDetail,
                    cardType: cardDetailType
                )
                .background(NUBackgroundClearView())
                .environmentObject(searchViewModel)
            }
        }
        .nuNavigationBar()
        .environmentObject(searchViewModel)
    }
}

struct SearchView_Previews: PreviewProvider {
    @Namespace static var namespace
    
    static var previews: some View {
        SearchView()
            .previewDevice("iPhone SE (1st generation)")
    }
}
