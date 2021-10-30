//
//  NutriScanApp.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

@main
struct NutriScanApp: App {
    @StateObject private var inAppPurchasesViewModel = InAppPurchasesViewModel()
    @StateObject private var favoritesViewModel = FavoritesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NUTabView()
                .environmentObject(inAppPurchasesViewModel)
                .environmentObject(favoritesViewModel)
                .preferredColorScheme(.dark)
        }
    }
}
