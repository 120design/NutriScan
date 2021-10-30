//
//  InAppPurchasesView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/10/2021.
//

import SwiftUI

struct InAppPurchasesView: View {
    @EnvironmentObject private var inAppPurchasesViewModel: InAppPurchasesViewModel
    
    var body: some View {
        VStack {
            Image(systemName: "lock.circle.fill")
                .font(.system(size: 80))
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())
            
            Text("*Vous utilisez la version gratuite* de NutriScan. Celle-ci *ne permet pas* de sauvegarder vos produits dans une liste de favoris.")
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())

            Text("Pour bénéficier d’une liste de favoris, *achetez la version payante de NutriScan* sur l’App Store *en pressant le bouton ci-dessous.*")
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())
           
            Button {
                Task {
                    do {
                        let purchaseState = try await inAppPurchasesViewModel.purchasePaidVersion()
                        print("InAppPurchasesView ~> purchase ~>", purchaseState)
                    } catch {
                        print("InAppPurchasesView ~> error ~>", error)
                    }
                }
            } label: {
                Text("Passer à la version payante (0,99 €)")
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity)
            .foregroundColor(.nuPrimaryColor)
            .background(Color.nuTertiaryColor)
            .modifier(NUSmoothCornersModifier(cornerRadius: 12))
            .modifier(NUButtonLabelModifier())
            .nuShadowModifier(color: .nuTertiaryColor)
        }
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.nuSecondaryColor)
    }
}

struct LiteVersionFavoritesView_Previews:
    PreviewProvider {
    static var previews: some View {
        InAppPurchasesView()
    }
}
