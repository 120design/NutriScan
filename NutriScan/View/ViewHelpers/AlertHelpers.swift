//
//  AlertHelpers.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 01/11/2021.
//

import SwiftUI

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
    
    static func cancel(
        _ label: String,
        action: @escaping (() -> Void) = {}
    )  -> Alert.Button {
        .cancel(
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
