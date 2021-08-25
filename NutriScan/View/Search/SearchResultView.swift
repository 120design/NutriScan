//
//  SearchResultView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject var searchManager: SearchManager
    @EnvironmentObject var cardDetailManager: CardDetailManager

    @Namespace private var namespace
    
    @ViewBuilder
    private var foundParagraph: some View {
        HStack {
            Text("NutriScan a trouvé dans ")
                + Text("la base de données d’Open Food Facts")
                .font(NUBodyTextEmphasisFont)
                + Text(" ce produit correspondant ")
                + Text("au code EAN \(searchManager.eanCode)")
                .font(NUBodyTextEmphasisFont)
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
                        cardDetailManager
                            .setCardDetailView(
                                namespace: namespace,
                                cardType: .product(product)
                            )
                    }, label: {
                        CardView(
                            namespace: namespace,
                            cardType: .product(product)
                        )
                    })
//                    .opacity(showDetail ? 0 : 1)
                } else {
                    Text("...")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
//            .onAppear(perform: getProduct)
        }
        .navigationTitle("Résultat")
        .foregroundColor(.nuSecondaryColor)
        .onAppear{
            cardDetailManager
                .cardDetailView = nil
        }
//        .overlay(
//            Group {
//                if showDetail,
//                   let product = product {
//                    CardDetailView(
//                        showDetail: $showDetail,
//                        eanCode: $fakeEanCode,
//                        goToResult: $goToResult,
//                        namespace: namespace,
//                        cardType: .product(product)
//                    )
//                }
//            }
//            .padding(.top)
//            .ignoresSafeArea()
//        )
    }
    
//    private func getProduct() {
//        //        guard let eanCode = eanCode else {
//        //            print("PAS DE CODE EAN !")
//        //            return
//        //        }
//
//    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}
