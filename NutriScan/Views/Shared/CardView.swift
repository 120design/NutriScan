//
//  CardView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 14/08/2021.
//

import SwiftUI

struct CardView: View {
    var namespace: Namespace.ID
    
    let cardType: CardType
    
    var body: some View {
        VStack {
            CardHeaderView(cardType: cardType, namespace: namespace)
                .matchedGeometryEffect(id: "header", in: namespace)
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
                .fill(Color.nuTertiaryColor)
                .matchedGeometryEffect(id: "container", in: namespace)
        )
        .modifier(NUTertiaryShadowModifier())
        .padding()
        .animation(.spring())
    }
}

struct NUCardView_Previews: PreviewProvider {
    @Namespace static var namespace
    let type = CardType.eanButton
    
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

enum CardType: String {
    case scanButton = "Scanner un code à\u{00a0}barres",
         eanButton = "Taper un code EAN13 ou EAN8"
}
