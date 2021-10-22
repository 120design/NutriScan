//
//  HistoryView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    @ObservedObject private var alertViewModel = AlertViewModel()
    
    @State private var showCardDetail = false
    @State private var productToShow: NUProduct? = nil
    
    private func handleFavorite(for product: NUProduct) {
        let productIsAFavorite = historyViewModel.productIsAFavorite(product)
        
        productIsAFavorite
        ? historyViewModel.removeProductFromFavorites(product)
        : historyViewModel.addProductToFavorites(product)
        
        alertViewModel.title = productIsAFavorite
        ? "Retrait du produit des favoris"
        : "Ajout du produit aux favoris"
        
        alertViewModel.message = productIsAFavorite
        ? "”\(product.name)” a été supprimé des favoris."
        : "”\(product.name)” a été ajouté aux favoris."
        
        alertViewModel.isPresented = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NUBackgroundView()
                List {
                    HStack {
                        Text("Consultez ici l’historique de vos cinq dernières recherches de produits.")
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .modifier(NUTextBodyModifier())
                    .frame(maxWidth: .infinity)
                    .padding([.top])
                    
                    ForEach(historyViewModel.products) { product in
                        Button (action: {
                            productToShow = product
                            showCardDetail = true
                        }, label: {
                            CardView(
                                cardType: .product(product)
                            )
                        })
                        .opacity(
                            showCardDetail
                                ? 0
                                : 1
                        )
                        .offset(
                            x: 0,
                            y: showCardDetail
                                ? 300
                            : 0
                        )
                        .animation(.spring(), value: showCardDetail)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .swipeActions {
                            Button {
                                handleFavorite(for: product)
                            } label: {
                                Label(
                                    historyViewModel.productIsAFavorite(product)
                                    ? "Retirer des favoris"
                                    : "Ajouter aux favoris",
                                    systemImage: historyViewModel.productIsAFavorite(product)
                                    ? "heart.slash.fill"
                                    : "arrow.down.heart.fill"
                                )
                            }
                            .tint(
                                historyViewModel.productIsAFavorite(product)
                                ? .nuSecondaryColor
                                : .nuTertiaryColor
                            )
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
               }
                .listStyle(.plain)
            }
            .navigationTitle("Historique")
            .foregroundColor(.nuSecondaryColor)
            .onAppear {
                historyViewModel.getHistoryProducts()
            }
            .alert(isPresented: $alertViewModel.isPresented) {
                Alert(viewModel: alertViewModel)
            }
            .fullScreenCover(isPresented: $showCardDetail) {
                productToShow = nil
            } content: {
                if let product = productToShow {
                    CardDetailView(
                        showDetail: $showCardDetail,
                        cardType: .product(product)
                    )
                    .background(NUBackgroundClearView())
                }
            }
        }
        .nuNavigationBar()
        .environmentObject(historyViewModel)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
