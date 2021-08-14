//
//  NUCardView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 14/08/2021.
//

import SwiftUI

struct NUCardView: View {
    let type: CardType
    enum CardType: String {
        case scanButton = "Scanner un code à\u{00a0}barres",
             eanButton = "Taper un code EAN13 ou EAN8"
    }
    
    let pictureWidth = screen.width * 0.25
    
    var body: some View {
        HStack(spacing: 12.0) {
            Image(
                systemName: type == .scanButton ? "barcode.viewfinder" : "textformat.123"
            )
            .resizable()
            .aspectRatio(contentMode: .fit)                .padding()
            .frame(width: pictureWidth, height: pictureWidth)
            
            .foregroundColor(.nuTertiaryColor)
            .background(Color.nuPrimaryColor)
            .modifier(NUSmoothCornersModifier())
            VStack {
                Text(type.rawValue)
                    .modifier(NUButtonLabelModifier())
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.nuTertiaryColor)
        .modifier(NUSmoothCornersModifier(cornerRadius: 28))
        .shadow(
            color: .nuTertiaryColor.opacity(0.4),
            radius: 70,
            x: 0,
            y: 12
        )
        .padding()
    }
}

struct NUCardView_Previews: PreviewProvider {
    static var previews: some View {
        NUCardView(type: .eanButton)
            .previewLayout(.fixed(width: 375, height: 200))
        
        NUCardView(type: .eanButton)
            .previewDevice("iPhone SE (1st generation)")
        NUCardView(type: .eanButton)
            .previewDevice("iPhone 11")
    }
}

let screen = UIScreen.main.bounds
