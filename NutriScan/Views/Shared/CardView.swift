//
//  CardView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 14/08/2021.
//

import SwiftUI
import Kingfisher

struct CardView: View {
    var namespace: Namespace.ID
    
    let cardType: CardType
    
    var body: some View {
        return VStack {
            CardHeaderView(cardType: cardType)
                .matchedGeometryEffect(id: "header", in: namespace)
        }
        .padding()
        .background(
            RoundedRectangle(
                cornerRadius: 28,
                style: .continuous
            )
            .fill(cardType.backgroundColor)
            .matchedGeometryEffect(id: "container", in: namespace)
        )
        .nuShadowModifier(color: cardType.backgroundColor)
        .padding()
        .animation(.spring())
    }
    
    enum CardType: Equatable {
        case scanButton,
             eanButton,
             product(NUProduct)
        
        var backgroundColor: Color {
            switch self {
            case .scanButton,
                 .eanButton:
                return .nuTertiaryColor
            case .product(_):
                return .nuQuaternaryColor
            }
        }
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
