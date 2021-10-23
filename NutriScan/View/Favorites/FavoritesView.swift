//
//  FavoritesView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 22/10/2021.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject private var favoritesViewModel: FavoritesViewModel
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
                List {
                    HStack {
                        Text("Ajoutez des produits depuis *l’historique* de vos recherches.")
                        Spacer()
                    }
                    .modifier(NUTextBodyModifier())
                    .frame(maxWidth: .infinity)
                    .padding([.leading, .trailing])
                    .padding(.top, 8)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                    
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
        .environmentObject(favoritesViewModel)
        .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView()
    }
}
