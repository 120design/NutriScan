//
//  NUModifiers.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 12/08/2021.
//

import SwiftUI

struct TextBodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("OperatorMono-Light", size: 16))
            .shadow(color: .nuSecondaryColor, radius: 4, x: 0, y: 0)
    }
}
