//
//  NUModifiers.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 12/08/2021.
//

import SwiftUI
import Kingfisher

// MARK: Typography

struct NUTextBodyModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(nuBodyLightTextFont)
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

let nuBodyLightTextFont: Font = .custom(
    lightFontName,
    size: 16
)

let nuBodyBookTextFont: Font = .custom(
    bookFontName,
    size: 16
)

let nuBodyMediumItalicFont: Font = .custom(
    mediumItalicFontName,
    size: 16
)

let nuBodyBoldItalicFont: Font = .custom(
    boldItalicFontName,
    size: 16
)

let nuTitleBoldItalicFont: Font = .custom(
    boldItalicFontName,
    size: 20
)

let nuProductDetailTextMediumItalicFont: Font = .custom(
    mediumItalicFontName,
    size: 12
)

let nuProductDetailTextLightFont: Font = .custom(
    lightFontName,
    size: 12
)

let nuProductInfoTextFont: Font = .custom(
    bookFontName,
    size: 12
)

let nuProductInfoTextBoldItalicFont: Font = .custom(
    boldItalicFontName,
    size: 12
)

let boldFontName = "OperatorMono-Bold"
let boldItalicFontName = "OperatorMono-BoldItalic"
let bookFontName = "OperatorMono-Book"
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
extension View {
    func nuSmoothCornersModifier(cornerRadius: CGFloat = 20) -> some View {
        self
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

extension View {
    func nuShadowModifier(color: Color) -> some View {
        self
            .shadow(
                color: color.opacity(0.2),
                radius: 24,
                x: 0,
                y: 12
            )
    }
}

extension View {
    func nuShadowTextModifier(color: Color) -> some View {
        self
            .shadow(
                color: color,
                radius: 4,
                x: 0,
                y: 0
            )
    }
}

extension View {
    func nuProductDetailCardTitleModifier(color: Color) -> some View {
        self
            .font(nuTitleBoldItalicFont)
            .foregroundColor(color)
            .shadow(
                color: color,
                radius: 8,
                x: 0,
                y: 0
            )
    }
}

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

// MARK: Images

extension Image {
    func nuCardHeaderImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
            .frame(width: pictureWidth, height: pictureWidth)
            .foregroundColor(.nuSecondaryColor)
            .background(Color.nuPrimaryColor)
            .modifier(NUSmoothCornersModifier())
    }
}
extension KFImage {
    func nuCardHeaderImageModifier() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: pictureWidth, height: pictureWidth)
            .foregroundColor(.nuTertiaryColor)
            .background(Color.nuPrimaryColor)
            .modifier(NUSmoothCornersModifier())
    }
}

// MARK: Infor card

extension View {
    func nuProductInfoCardModifier() -> some View {
        self
            .padding(10.0)
            .frame(maxWidth: .infinity)
            .background(Color.nuPrimaryColor)
            .nuSmoothCornersModifier()
            .padding(.horizontal)
            .padding(.top, 5)
    }
}
