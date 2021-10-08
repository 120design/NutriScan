//
//  SearchResultView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var searchManager: SearchManager
    
    @State var showCardDetail = false
    
    @ViewBuilder
    private var foundParagraph: some View {
        HStack {
            Text("NutriScan a trouvé dans ")
                + Text("la base de données d’Open Food Facts")
                .font(nuBodyMediumItalicFont)
                + Text(" ce produit correspondant ")
                + Text("au code EAN \(searchManager.eanCode)")
                .font(nuBodyMediumItalicFont)
                + Text(" :")
        }
        .modifier(NUTextBodyModifier())
        .frame(maxWidth: .infinity)
        .padding([.top, .leading, .trailing])
    }
    
    var body: some View {
        ZStack {
            NUBackgroundView()
            VStack {
                if let product = searchManager.foundProduct {
                    foundParagraph
                    
                    Button (action: {
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

                } else {
                    VStack {
                        Spacer()
                        ProgressView("Recherche en cours")
                            .progressViewStyle(
                                CircularProgressViewStyle(tint: .nuQuaternaryColor)
                            )
                            .foregroundColor(.nuQuaternaryColor)
                        Spacer()
                    }
                }
                
                Spacer()
            }
        }
        .navigationTitle("Résultat")
        .foregroundColor(.nuSecondaryColor)
        .fullScreenCover(isPresented: $showCardDetail) {
            if let product = searchManager.foundProduct {
                CardDetailView(
                    showDetail: $showCardDetail,
                    cardType: .product(product)
                )
                .background(NUBackgroundClearView())
            }
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}
