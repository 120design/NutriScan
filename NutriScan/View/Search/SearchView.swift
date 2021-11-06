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
            
    var body: some View {
        NavigationView {
            ZStack {
                NUBackgroundView()
                ScrollView {
                    Text("Rercherchez un produit *en scannant son code à barres* ou *en tapant le numéro EAN* à huit ou treize chiffres inscrit sous son code à barres.")
                    .modifier(NUTextBodyModifier())
                    .frame(maxWidth: .infinity)
                    .padding()
                    
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
                        .padding(.top, -5.0)
                        .padding(.bottom, 2)
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
                    .padding(.bottom)
                    .animation(.spring(), value: searchViewModel.showCardDetail)
                    if let foundProduct = searchViewModel.foundProduct {
                        NavigationLink(
                            destination: SearchResultView(products: [foundProduct]),
                            isActive: $searchViewModel.showResult,
                            label: {
                                EmptyView()
                            }
                        )
                    }
                }
            }
            .navigationTitle("Recherche")
            .foregroundColor(.nuSecondaryColor)
            .fullScreenCover(isPresented: $searchViewModel.showCardDetail) {
                CardDetailView(
                    showDetail: $searchViewModel.showCardDetail,
                    currentlyResearching: searchViewModel.currentlyResearching,
                    cardType: cardDetailType,
                    cancelHTTPRequest: cardDetailType == .scanButton
                    || cardDetailType == .eanButton
                    ? searchViewModel.cancelRequest
                    : nil
                )
                    .background(NUBackgroundClearView())
                    .environmentObject(searchViewModel)
                    .alert(isPresented: $searchViewModel.alertViewModel.isPresented) {
                        searchViewModel.alertViewModel.primaryButton = .default("J’ai compris") { }
                        return Alert(viewModel: searchViewModel.alertViewModel)
                    }
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
