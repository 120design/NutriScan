//
//  AlertViewModel.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 22/10/2021.
//

import SwiftUI

final class AlertViewModel: ObservableObject {
    var title: String
    var message: String
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button?
    
    @Published var isPresented = false
    
    init(
        title: String = "",
        message: String = "",
        primaryButton: Alert.Button = .default("OK"),
        secondaryButton: Alert.Button? = nil
    ) {
        self.title = title
        self.message = message
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }
}
