//
//  FavoritesView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 22/10/2021.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
    @EnvironmentObject private var inAppPurchasesViewModel: InAppPurchasesViewModel
    @ObservedObject private var alertViewModel = AlertViewModel()
    
    @State private var showCardDetail = false
    @State private var productToShow: NUProduct? = nil
    
    @State private var editingList = false
    
    private func handleFavorite(for product: NUProduct) {
        alertViewModel.title = "Suppression du produit des favoris"
        
        alertViewModel.message = "Souhaitez-vous réellement supprimer ”\(product.name)” des favoris ?"
        
        alertViewModel.primaryButton = .default("Annuler") { }
        
        alertViewModel.secondaryButton = .destructive("Supprimer") {
            favoritesViewModel.removeProductFromFavorites(product)
        }
        
        alertViewModel.isPresented = true
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NUBackgroundView()
                
                if favoritesViewModel.favoritesAreGranted
                {
                    List {
                        Text("Ajoutez des produits depuis *l’historique de vos recherches* puis retrouvez-les ici.")
                        .modifier(NUTextBodyModifier())
                        .frame(maxWidth: .infinity)
                        .padding([.leading, .trailing])
                        .padding(.top, 8)
                        .padding(.bottom, favoritesViewModel.products.isEmpty ? 8 : 0)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        
                        if !favoritesViewModel.products.isEmpty {
                            Text("Pour supprimer ou ré-ordonner les favoris, exercez une longue pression sur un des favoris.")
                            .modifier(NUTextBodyModifier())
                            .frame(maxWidth: .infinity)
                            .padding([.leading, .trailing])
                            .padding(.bottom, 8)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        }
                        
                        ForEach(favoritesViewModel.products) { product in
                            Button (action: { }, label: {
                                CardView(
                                    cardType: favoritesViewModel.getCardType(for: product)
                                )
                            })
                                .highPriorityGesture(
                                    TapGesture()
                                        .onEnded {
                                            if !editingList {
                                                productToShow = product
                                                showCardDetail = true
                                            }
                                            editingList = false
                                        }
                                )
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
                                    Button(role: .destructive) {
                                        handleFavorite(for: product)
                                        editingList.toggle()
                                    } label: {
                                        Label("Supprimer des favoris", systemImage: "trash.fill")
                                    }
                                }
                        }
                        .onMove { from, to in
                            favoritesViewModel.moveProduct(from: from, to: to)
                            withAnimation {
                                editingList = false
                            }
                        }
                        .onDelete { indexSet in
                            favoritesViewModel.removeProductFromFavorites(indexSet: indexSet)
                            withAnimation {
                                editingList = false
                            }
                        }
                        .onLongPressGesture {
                            withAnimation {
                                editingList.toggle()
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(.plain)
                } else {
                    InAppPurchasesView()
                }
            }
            .navigationTitle("Favoris")
            .foregroundColor(.nuSecondaryColor)
            .onAppear {
                favoritesViewModel.getFavoritesProducts()
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
                        cardType: favoritesViewModel.getCardType(for: product)
                    )
                        .background(NUBackgroundClearView())
                }
            }
        }
        .nuNavigationBar()
        .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
        .onReceive(inAppPurchasesViewModel.$paidVersionIsPurchased) { paidVersionIsPurchased in
            guard let paidVersionIsPurchased = paidVersionIsPurchased
            else {
                favoritesViewModel.favoritesAreGranted = false
                return
            }
            
            favoritesViewModel.favoritesAreGranted = paidVersionIsPurchased
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
