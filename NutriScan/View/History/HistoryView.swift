//
//  HistoryView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var historyViewModel = HistoryViewModel()
    
    @State private var showCardDetail = false
    @State private var productToShow: NUProduct? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                NUBackgroundView()
                ScrollView {
                    HStack {
                        Text("Consultez ici l’historique de vos cinq dernières recherches de produits.")
                    }
                    .modifier(NUTextBodyModifier())
                    .frame(maxWidth: .infinity)
                    .padding([.top, .leading, .trailing])
                    
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
                        .animation(.spring())
                    }
                }
            }
            .navigationTitle("Historique")
            .foregroundColor(.nuSecondaryColor)
            .onAppear {
                historyViewModel.getAllProducts()
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
