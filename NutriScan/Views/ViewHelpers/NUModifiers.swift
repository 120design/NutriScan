//
//  NUModifiers.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 12/08/2021.
//

import SwiftUI

// MARK: Typography

struct NUTextBodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(NUBodyTextFont)
            .shadow(
                color: .nuSecondaryColor,
                radius: 4,
                x: 0,
                y: 0
            )
    }
}

struct NUButtonLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                .custom(
                    boldFontName,
                    size: 20
                )
            )
            .foregroundColor(.nuPrimaryColor)
    }
}

struct NUStrongLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                .custom(
                    mediumFontName,
                    size: 34
                )
            )
            .foregroundColor(.nuQuaternaryColor)
            .shadow(
                color: .nuQuaternaryColor,
                radius: 4,
                x: 0,
                y: 0
            )

    }
}

let NUBodyTextFont: Font = .custom(
    lightFontName,
    size: 16
)

let NUBodyTextEmphasisFont: Font = .custom(
    mediumItalicFontName,
    size: 16
)

let boldFontName = "OperatorMono-Bold"
let mediumFontName = "OperatorMono-Medium"
let mediumItalicFontName = "OperatorMono-MediumItalic"
let lightFontName = "OperatorMono-Light"

// MARK: Corner Radius

struct NUSmoothCornersModifier: ViewModifier {
    var cornerRadius: CGFloat = 20
    func body(content: Content) -> some View {
        content
            .clipShape(
                RoundedRectangle(
                    cornerRadius: cornerRadius,
                    style: .continuous
                )
            )
    }
}

// MARK: Gradient Background

struct NUBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient:
                Gradient(
                    colors: [.nuQuinaryColor, .nuPrimaryColor]
                ),
            startPoint: UnitPoint(x: 0.5, y: 0.55),
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

// MARK: Shadow

struct NUPrimaryShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .nuPrimaryColor.opacity(0.2),
                radius: 24,
                x: 0,
                y: 12
            )
    }
}

struct NUTertiaryShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .nuTertiaryColor.opacity(0.2),
                radius: 24,
                x: 0,
                y: 12
            )
    }
}

struct NUQuaternaryShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(
                color: .nuQuaternaryColor.opacity(0.2),
                radius: 24,
                x: 0,
                y: 12
            )
    }
}

// MARK: TextField

struct NUPlaceholderStyleModifier: ViewModifier {
    var showPlaceHolder: Bool
    var placeholder: String
    var foregroundColor: Color
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            if showPlaceHolder {
                Text(placeholder)
                    .padding(.horizontal, 15)
                    .foregroundColor(foregroundColor.opacity(0.4))
            }
            content
        }
    }
}
