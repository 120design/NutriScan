//
//  CardView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 14/08/2021.
//

import SwiftUI

struct CardView: View {
    let namespace: Namespace.ID
    
    let cardType: CardType
    enum CardType: String {
        case scanButton = "Scanner un code à\u{00a0}barres",
             eanButton = "Taper un code EAN13 ou EAN8"
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 12.0) {
                Image(
                    systemName: cardType == .scanButton
                        ? "barcode.viewfinder"
                        : "textformat.123"
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
                .frame(width: pictureWidth, height: pictureWidth)
                .foregroundColor(.nuTertiaryColor)
                .background(Color.nuPrimaryColor)
                .modifier(NUSmoothCornersModifier())
                VStack {
                    Text(cardType.rawValue)
                        .modifier(NUButtonLabelModifier())
                }
                Spacer()
            }
            .matchedGeometryEffect(id: "header", in: namespace)
            .padding()
            .frame(maxWidth: .infinity)
        }
        .background(
            Color
                .nuTertiaryColor
                .matchedGeometryEffect(id: "container", in: namespace)
                .mask(
                    RoundedRectangle(
                        cornerRadius: 28,
                        style: .continuous
                    )
                    .matchedGeometryEffect(id: "shape", in: namespace)
                )
        )
        .modifier(NUTertiaryShadowModifier())
        .padding()
        .animation(.spring())
    }
}

struct NUCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    let type = CardView.CardType.eanButton
    
    static var previews: some View {
        CardView(
            namespace: namespace,
            cardType: .eanButton
        )
        .previewLayout(.fixed(width: 375, height: 200))
        
        CardView(namespace: namespace, cardType: .eanButton)
            .previewDevice("iPhone SE (1st generation)")
        CardView(namespace: namespace, cardType: .eanButton)
            .previewDevice("iPhone 11")
    }
}


let screen = UIScreen.main.bounds
let pictureWidth = screen.width * 0.25
