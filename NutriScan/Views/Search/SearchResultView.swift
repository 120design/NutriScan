//
//  SearchResultView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/12/2020.
//

import SwiftUI

struct SearchResultView: View {
    @State var product: NUProduct?
    @State var showDetail = false
    
    @State var goToResult = false
    
    let eanCode: String
    
    @Namespace private var namespace
    
    @ViewBuilder
    var foundParagraph: some View {
        HStack {
            Text("NutriScan a trouvé dans ")
                + Text("la base de données d’Open Food Facts")
                .font(NUBodyTextEmphasisFont)
                + Text(" ce produit correspondant ")
                + Text("au code EAN \(eanCode)")
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
                if let product = product {
                    foundParagraph
                    Button(action: {
                        self.showDetail = true
                    }, label: {
                        CardView(
                            namespace: namespace,
                            cardType: .product(product)
                        )
                    })
                    .opacity(showDetail ? 0 : 1)
                } else {
                    Text("...")
                        .foregroundColor(.white)
                }
                
                Spacer()
            }
            .onAppear(perform: getProduct)
        }
        .navigationTitle("Résultat")
        .foregroundColor(.nuSecondaryColor)
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
    
    private func getProduct() {
        //        guard let eanCode = eanCode else {
        //            print("PAS DE CODE EAN !")
        //            return
        //        }
        OFFService.shared.getProduct(from: eanCode) { (error, product) in
            if let error = error {
                print("ERROR :", error)
            }
            guard let product = product else {
                print("PRODUCT ERROR")
                return
            }
            self.product = product
        }
    }
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView(eanCode: "lol")
    }
}
