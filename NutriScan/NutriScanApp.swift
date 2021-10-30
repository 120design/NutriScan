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
        
    let storageManager = StorageManager.shared
    
    var body: some Scene {
        WindowGroup {
            NUTabView()
                .environment(\.managedObjectContext, storageManager.persistentContainer.viewContext)
                .environmentObject(inAppPurchasesViewModel)
                .environmentObject(favoritesViewModel)
                .onReceive(inAppPurchasesViewModel.$paidVersionIsPurchased) { paidVersionIsPurchased in
                    guard let paidVersionIsPurchased = paidVersionIsPurchased
                    else {
                        storageManager.maxHistory = HistoryViewModel.MaxHistory.low.int
                        return
                    }
                    
                    storageManager.maxHistory = paidVersionIsPurchased ? HistoryViewModel.MaxHistory.high.int : HistoryViewModel.MaxHistory.low.int
                }
                .preferredColorScheme(.dark)
        }
    }
}
