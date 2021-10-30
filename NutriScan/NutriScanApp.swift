//
//  NutriScanApp.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/12/2020.
//

import SwiftUI

@main
struct NutriScanApp: App {
    let storageManager = StorageManager.shared
    
    var body: some Scene {
        WindowGroup {
            NUTabView()
                .environment(\.managedObjectContext, storageManager.persistentContainer.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
