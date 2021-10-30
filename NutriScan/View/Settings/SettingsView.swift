//
//  SettingsView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 30/10/2021.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            ZStack {
                NUBackgroundView()
                
                InAppPurchasesView()
            }
            .navigationTitle("Réglages")
            .foregroundColor(.nuSecondaryColor)
        }
        .nuNavigationBar()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
