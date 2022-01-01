//
//  InAppPurchasesView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/10/2021.
//

import SwiftUI

struct InAppPurchasesView: View {
    @EnvironmentObject private var inAppPurchasesViewModel: InAppPurchasesViewModel
    @ObservedObject private var alertViewModel = AlertViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "lock.circle.fill")
                .font(.system(size: 80))
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())
            
            Text("*Vous utilisez la version gratuite* de NutriScan. Celle-ci ne conserve l’historique que de vos \(HistoryViewModel.MaxHistory.low.rawValue) dernières recherches et *ne permet pas* de sauvegarder vos produits dans une liste de favoris.")
                .padding(.bottom, 8)
                .modifier(NUSmallTextBodyModifier())
            
            Text("Pour bénéficier *d’une liste de favoris* et conserver l’historique que de vos \(HistoryViewModel.MaxHistory.high.rawValue) dernières recherches, *achetez la version payante de NutriScan* sur l’App Store *en pressant le bouton ci-dessous.*")
                .padding(.bottom, 8)
                .modifier(NUSmallTextBodyModifier())
            
            Button {
                Task {
                    do {
                        try await inAppPurchasesViewModel.purchasePaidVersion()
                    } catch {
                        print("InAppPurchasesView ~> error ~>", error)
                    }
                }
            } label: {
                Text("Passer à la version payante (0,99\u{00a0}€)")
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 6)
            .frame(maxWidth: .infinity)
            .foregroundColor(.nuPrimaryColor)
            .background(Color.nuTertiaryColor)
            .modifier(NUSmoothCornersModifier(cornerRadius: 12))
            .modifier(NUSmallButtonLabelModifier())
            .nuShadowModifier(color: .nuTertiaryColor)
            
            Button("Restaurer cet achat", action: {
                inAppPurchasesViewModel.restorePurchases()
            })
        }
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.nuSecondaryColor)
        .alert(isPresented: $alertViewModel.isPresented) {
            Alert(viewModel: alertViewModel)
        }
    }
}

struct LiteVersionFavoritesView_Previews:
    PreviewProvider {
    static var previews: some View {
        InAppPurchasesView()
            .environmentObject(InAppPurchasesViewModel())
    }
}
