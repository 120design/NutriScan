//
//  LiteVersionFavoritesView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 23/10/2021.
//

import SwiftUI

struct LiteVersionFavoritesView: View {
    var body: some View {
        VStack {
            Image(systemName: "lock.circle.fill")
                .font(.system(size: 80))
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())
            
            Text("*Vous utilisez la version LITE* de NutriScan. Celle-ci *ne permet pas* de sauvegarder vos produits dans une liste de favoris.")
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())

            Text("Pour bénéficier d’une liste de favoris, *achetez la version PRO de NutriScan* sur l’App Store *en pressant le bouton ci-dessous.*")
                .padding(.bottom, 8)
                .modifier(NUTextBodyModifier())
           
            Button {
                if let url = URL(string: "itms-apps://apple.com/app/id1576078398") {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text(
                    "Installer NutriScan PRO"
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
        }
        .padding()
        .multilineTextAlignment(.center)
        .foregroundColor(.nuSecondaryColor)
    }
}

struct LiteVersionFavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        LiteVersionFavoritesView()
    }
}
