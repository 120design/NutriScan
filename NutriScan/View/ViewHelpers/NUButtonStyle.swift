//
//  NUButtonStyle.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/08/2021.
//

import SwiftUI

struct NUButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        NUButtonView(color: .nuTertiaryColor, configuration: configuration)
    }
}

private extension NUButtonStyle {
    struct NUButtonView: View {
        // tracks if the button is enabled or not
        @Environment(\.isEnabled) var isEnabled
        
        var color: Color
        
        // tracks the pressed state
        let configuration: NUButtonStyle.Configuration
        
        var body: some View {
            return configuration.label
                // change the text color based on if it's disabled
                .foregroundColor(isEnabled ? color : color.opacity(0.4))
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        // change the background color based on if it's disabled
                        .fill(isEnabled ? color : color.opacity(0.4))
                )
                // make the button a bit more translucent when pressed
                .opacity(configuration.isPressed ? 0.8 : 1.0)
                
                // make the button a bit smaller when pressed
                .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
        }
    }
}
