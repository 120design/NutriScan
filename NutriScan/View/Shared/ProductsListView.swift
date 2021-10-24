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
                ForEach(0..<headerParagraphs.count) { index in
                    if let attributedString = try? AttributedString(markdown: headerParagraphs[index])
                    {
                        HStack {
                            Text(attributedString)
                            Spacer()
                        }
                        .modifier(NUTextBodyModifier())
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing])
                        .padding(.top, index == 0 ? 8 : 0)
                        .padding(.bottom, index == headerParagraphs.count - 1 ? 8 : 0)
                    }
                }
                .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                
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
    @StateObject static private var favoritesViewModel = FavoritesViewModel()
    
    static var previews: some View {
        NavigationView {
            ProductsListView(
                navigationTitle: "Historique",
                products: [
                    NUProduct(
                        id: "1234",
                        name: "Moutarde de Dijon",
                        imageURL: "",
                        nutriments: Nutriments(
                            fiber_100g: 10,
                            carbohydrates_100g: 8.5,
                            proteins_100g: 8.5,
                            fat_100g: 4.2,
                            salt_100g: 25.12,
                            energy_kj_100g: 100,
                            energy_kcal_100g: 100
                        ),
                        nutriScore: nil,
                        novaGroup: nil,
                        ecoScore: nil
                    ),
                    NUProduct(
                        id: "1235",
                        name: "Moutarde de Dijon",
                        imageURL: "",
                        nutriments: Nutriments(
                            fiber_100g: 10,
                            carbohydrates_100g: 8.5,
                            proteins_100g: 8.5,
                            fat_100g: 4.2,
                            salt_100g: 25.12,
                            energy_kj_100g: 100,
                            energy_kcal_100g: 100
                        ),
                        nutriScore: nil,
                        novaGroup: nil,
                        ecoScore: nil
                    ),
                ],
                headerParagraphs: ["Scannez le code à barres d’un produit avec votre téléphone, NutriScan interrogera alors la base de données de l’Open Food Facts, un projet open source qui recense les informations nutritionnelles de plus de 700 000 produits alimentaires.", "Scannez le code à barres d’un produit avec votre téléphone, NutriScan interrogera alors la base de données de l’Open Food Facts, un projet open source qui recense les informations nutritionnelles de plus de 700 000 produits alimentaires."]
            )
                .environmentObject(favoritesViewModel)
        }
        .nuNavigationBar()
    }
}
