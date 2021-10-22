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

extension Alert.Button {
    static func `default`(
        _ label: String,
        action: @escaping (() -> Void) = {}
    )  -> Alert.Button {
        .default(
            Text(label),
            action: action
        )
    }
    
    static func destructive(
        _ label: String,
        action: @escaping (() -> Void) = {}
    )  -> Alert.Button {
        .destructive(
            Text(label),
            action: action
        )
    }
}

extension Alert {
    init(viewModel: AlertViewModel) {
        if let secondaryButton = viewModel.secondaryButton {
            self.init(
                title: Text(viewModel.title),
                message: Text(viewModel.message),
                primaryButton: viewModel.primaryButton,
                secondaryButton: secondaryButton
            )
        } else {
            self.init(
                title: Text(viewModel.title),
                message: Text(viewModel.message),
                dismissButton: viewModel.primaryButton
            )
        }
    }
}
