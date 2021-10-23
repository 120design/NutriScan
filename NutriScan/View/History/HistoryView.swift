//
//  HistoryView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
//    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
//    @ObservedObject private var alertViewModel = AlertViewModel()
//
//    @State private var showCardDetail = false
//    @State private var productToShow: NUProduct? = nil
//
//    private func handleFavorite(for product: NUProduct) {
//        let productIsAFavorite = favoritesViewModel.productIsAFavorite(product)
//
//        alertViewModel.title = productIsAFavorite
//        ? "Retrait du produit des favoris"
//        : "Ajout du produit aux favoris"
//
//        alertViewModel.message = productIsAFavorite
//        ? "”\(product.name)” est supprimé de vos favoris mais reste sauvegardé dans l’historique de vos recherches."
//        : "”\(product.name)” est ajouté à vos favoris."
//
//        if productIsAFavorite {
//            alertViewModel.primaryButton = .destructive("Merci, j’ai bien compris") {
//                favoritesViewModel.removeProductFromFavorites(product)
//            }
//        } else {
//            alertViewModel.primaryButton = .default("Merci, j’ai bien compris") {
//                favoritesViewModel.addProductToFavorites(product)
//            }
//        }
//
//        alertViewModel.isPresented = true
//    }
        
    var body: some View {
        NavigationView {
            ProductsListView(
                navigationTitle: "Historique",
                products: historyViewModel.products,
                headerParagraphs: [
                    "Consultez ici *l’historique de vos trois dernières recherches* de produits.",
                    "Vous pouvez *ajouter un produit à vos favoris* ou l’en supprimer *en le faisant glisser vers la gauche* pour faire apparaître le bouton prévu à cet effet."
                ]
            )
                .onAppear {
                    historyViewModel.getHistoryProducts()
                }
//            ZStack {
//                NUBackgroundView()
//                List {
//                    HStack {
//                        Text("Consultez ici l’historique de vos trois dernières recherches de produits.")
//                        Spacer()
//                    }
//                    .modifier(NUTextBodyModifier())
//                    .frame(maxWidth: .infinity)
//                    .padding([.leading, .trailing])
//                    .padding(.top, 8)
//                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.clear)
//                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
//
//                    ForEach(historyViewModel.products) { product in
//                        Button (action: {
//                            productToShow = product
//                            showCardDetail = true
//                        }, label: {
//                            CardView(
//                                cardType: favoritesViewModel.getCardType(for: product)
//                            )
//                        })
//                        .opacity(
//                            showCardDetail
//                                ? 0
//                                : 1
//                        )
//                        .offset(
//                            x: 0,
//                            y: showCardDetail
//                                ? 300
//                            : 0
//                        )
//                        .animation(.spring(), value: showCardDetail)
//                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
//                        .swipeActions {
//                            let productIsAFavorite = favoritesViewModel.productIsAFavorite(product)
//
//                            Button {
//                                handleFavorite(for: product)
//                            } label: {
//                                Label(
//                                    productIsAFavorite
//                                    ? "Retirer des favoris"
//                                    : "Ajouter aux favoris",
//                                    systemImage: productIsAFavorite
//                                    ? "bookmark.slash"
//                                    : "bookmark"
//                                )
//                            }
//                            .tint(
//                                productIsAFavorite
//                                ? .red
//                                : .nuTertiaryColor
//                            )
//                        }
//                    }
//                    .listRowSeparator(.hidden)
//                    .listRowBackground(Color.clear)
//               }
//                .listStyle(.plain)
//            }
//            .navigationTitle("Historique")
//            .foregroundColor(.nuSecondaryColor)
//            .onAppear {
//                historyViewModel.getHistoryProducts()
//            }
//            .alert(isPresented: $alertViewModel.isPresented) {
//                return Alert(viewModel: alertViewModel)
//            }
//            .fullScreenCover(isPresented: $showCardDetail) {
//                productToShow = nil
//            } content: {
//                if let product = productToShow {
//                    CardDetailView(
//                        showDetail: $showCardDetail,
//                        cardType: favoritesViewModel.getCardType(for: product)
//                    )
//                    .background(NUBackgroundClearView())
//                }
//            }
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
