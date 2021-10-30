//
//  CheckingVersionView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 28/10/2021.
//

import SwiftUI

struct CheckingVersionView: View {
    @StateObject private var inAppPurchaseViewModel = InAppPurchasesViewModel()
        
    var body: some View {
        ZStack {
            NUBackgroundView()
            VStack {
//                if inAppPurchaseViewModel.purchasedProductsIDs.isEmpty {
                if let paidVersionIsPurchased = inAppPurchaseViewModel.paidVersionIsPurchased,
                   paidVersionIsPurchased
                {
                    Text("Vous utilisez *la version gratuite de NutriScan* qui vous permet de sauvegarder *vos trois dernières recherches* de produits.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                        .modifier(NUTextBodyModifier())
                    
                    Text("La version payante de NutriScan vous permettrait de sauvegarder sur votre téléphone *l’historique de vos dix dernières recherches* et autant de *produits favoris* que vous le souhaitez.")
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)
                        .modifier(NUTextBodyModifier())

                    Button {
                        Task {
                            do {
                                let purchase = try await inAppPurchaseViewModel.purchase()
                                print("CheckVersionView ~> purchase ~>", purchase)
                            } catch {
                                print("CheckVersionView ~> error ~>", error)
                            }
                        }
                    } label: {
                        Text(
                            "Passer à la version payante (0,99 €)"
                        )
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 6)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.nuPrimaryColor)
                    .background(Color.nuTertiaryColor)
                    .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                    .modifier(NUButtonLabelModifier())
                    .nuShadowModifier(color: .nuTertiaryColor)
                } else {
                    Text("Version payante utilisée")
                }
            }
            .padding()
            .foregroundColor(.nuSecondaryColor)
        }
        .task {
            Task {
                await inAppPurchaseViewModel.checkIfPaidVersionIsPurchased()
            }
        }
        .environmentObject(inAppPurchaseViewModel)
    }
}

struct CheckingVersionView_Previews: PreviewProvider {
    static var previews: some View {
        CheckingVersionView()
    }
}
