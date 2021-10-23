//
//  ProductsListView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/10/2021.
//

import SwiftUI

struct ProductsListView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @ObservedObject private var alertViewModel = AlertViewModel()
    
    @State private var showCardDetail = false
    @State private var productToShow: NUProduct? = nil
    
    let navigationTitle: String
    
    let products: [NUProduct]
    
    let headerParagraphs: [String]
    
    private func handleFavorite(for product: NUProduct) {
        if nuProVersion {
            let productIsAFavorite = favoritesViewModel.productIsAFavorite(product)
            
            alertViewModel.title = productIsAFavorite
            ? "Retrait du produit des favoris"
            : "Ajout du produit aux favoris"
            
            alertViewModel.message = productIsAFavorite
            ? "”\(product.name)” est supprimé de vos favoris mais reste sauvegardé dans l’historique de vos recherches."
            : "”\(product.name)” est ajouté à vos favoris."
            
            if productIsAFavorite {
                alertViewModel.primaryButton = .destructive("Merci, j’ai bien compris") {
                    favoritesViewModel.removeProductFromFavorites(product)
                }
            } else {
                alertViewModel.primaryButton = .default("Merci, j’ai bien compris") {
                    favoritesViewModel.addProductToFavorites(product)
                }
            }
        } else {
            alertViewModel.title = "Ajout du produit aux favoris"
            
            alertViewModel.message = "L’ajout du produit aux favoris n’est possible que dans la version PRO de NutriScan."
            
            alertViewModel.primaryButton = .destructive("Annuler") { }
            
            alertViewModel.secondaryButton = .default("Installer la version PRO") {
                if let url = URL(string: "itms-apps://apple.com/app/id1576078398") {
                    UIApplication.shared.open(url)
                }
            }
        }
        
        alertViewModel.isPresented = true
    }
    
    var body: some View {
        ZStack {
            NUBackgroundView()
            List {
                ForEach(headerParagraphs, id: \.self) { headerParagraph in
                    if let attributedString = try? AttributedString(markdown: headerParagraph)
                    {
                        HStack {
                            Text(attributedString)
                            Spacer()
                        }
                        .modifier(NUTextBodyModifier())
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing])
                        .padding(.bottom, 8)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0))
                
                ForEach(products) { product in
                    Button (action: {
                        productToShow = product
                        showCardDetail = true
                    }, label: {
                        CardView(
                            cardType: favoritesViewModel.getCardType(for: product)
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
                            let productIsAFavorite = favoritesViewModel.productIsAFavorite(product)
                            
                            Button {
                                handleFavorite(for: product)
                            } label: {
                                Label(
                                    productIsAFavorite
                                    ? "Retirer des favoris"
                                    : "Ajouter aux favoris",
                                    systemImage: productIsAFavorite
                                    ? "bookmark.slash"
                                    : "bookmark"
                                )
                            }
                            .tint(
                                productIsAFavorite
                                ? .red
                                : .nuTertiaryColor
                            )
                        }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .padding(.top)
        }
        .navigationTitle(navigationTitle)
        .foregroundColor(.nuSecondaryColor)
        .alert(isPresented: $alertViewModel.isPresented) {
            return Alert(viewModel: alertViewModel)
        }
        .fullScreenCover(isPresented: $showCardDetail) {
            productToShow = nil
        } content: {
            if let product = productToShow {
                CardDetailView(
                    showDetail: $showCardDetail,
                    cardType: favoritesViewModel.getCardType(for: product)
                )
                    .background(NUBackgroundClearView())
            }
        }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsListView(
            navigationTitle: "Historique",
            products: [],
            headerParagraphs: []
        )
    }
}
