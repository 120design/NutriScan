//
//  InAppPurchasesView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/10/2021.
//

import SwiftUI
import StoreKit

struct InAppPurchasesView: View {
    @EnvironmentObject private var inAppPurchasesViewModel: InAppPurchasesViewModel
    @ObservedObject private var alertViewModel = AlertViewModel()
    
    private func presentPurchaseAlert() {
        alertViewModel.title = "Demande de remboursement"
        
        alertViewModel.message = "Souhaitez-vous réellement supprimer revenir à la version gratuite de NutriScan ? Vous serez reboursé par Apple sous 48 h 00."
        
        alertViewModel.primaryButton = .default("Annuler") { }
        
        alertViewModel.secondaryButton = .destructive("Demander le remboursement") {
            inAppPurchasesViewModel.getFreeVersion()
        }
        
        alertViewModel.isPresented = true
    }
    
    private func presentRefundAlert() {
        alertViewModel.title = "Demande de remboursement"
        
        alertViewModel.message = "Souhaitez-vous réellement supprimer revenir à la version gratuite de NutriScan ? Vous serez reboursé par Apple sous 48 h 00."
        
        alertViewModel.primaryButton = .default("Annuler") { }
        
        alertViewModel.secondaryButton = .destructive("Demander le remboursement") {
            inAppPurchasesViewModel.getFreeVersion()
        }
        
        alertViewModel.isPresented = true
    }
    
    var body: some View {
        VStack {
            if inAppPurchasesViewModel.paidVersionIsPurchased ?? false {
                
                Text("*Vous utilisez la version Payante* de NutriScan. Celle-ci conserve vos \(HistoryViewModel.MaxHistory.high.rawValue) dernières recherches et vous permet de *sauvegarder vos produits dans une liste de favoris*.")
                    .padding(.bottom, 8)
                    .modifier(NUSmallTextBodyModifier())

                Text("Si cette version payante ne vous convient pas, *vous pouvez demander un remboursement* en pressant sur le bouton ci-dessous.")
                    .padding(.bottom, 8)
                    .modifier(NUSmallTextBodyModifier())

                Text("*Vous reviendrez alors à la version gratuite* qui ne conserve l’historique que de vos \(HistoryViewModel.MaxHistory.low.rawValue) dernières recherches et qui *ne permet pas* de sauvegarder vos produits dans une liste de favoris.")
                    .padding(.bottom, 8)
                    .modifier(NUSmallTextBodyModifier())
                
                Button {
                    presentRefundAlert()
                } label: {
                    Text("Demander un remboursement")
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 6)
                .frame(maxWidth: .infinity)
                .foregroundColor(.nuPrimaryColor)
                .background(Color.nuSecondaryColor)
                .modifier(NUSmoothCornersModifier(cornerRadius: 12))
                .modifier(NUSmallButtonLabelModifier())
                .nuShadowModifier(color: .nuSecondaryColor)

            } else {
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
                            let purchaseState = try await inAppPurchasesViewModel.purchasePaidVersion()
                            print("InAppPurchasesView ~> purchase ~>", purchaseState)
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
                    Task {
                        //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                        //Call this function only in response to an explicit user action, such as tapping a button.
                        try? await AppStore.sync()
                    }
                })
            }
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
