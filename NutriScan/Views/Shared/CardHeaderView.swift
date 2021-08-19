//
//  CardHeaderView.swift
//  CardHeaderView
//
//  Created by Vincent Caronnet on 16/08/2021.
//

import SwiftUI

struct CardHeaderView: View {
    let cardType: CardType
    var namespace: Namespace.ID
    
    var body: some View {
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
//                .matchedGeometryEffect(id: "image", in: namespace)
            VStack {
                Text(cardType.rawValue)
//                    .matchedGeometryEffect(id: "title", in: namespace)
                    .multilineTextAlignment(.leading)
                    .modifier(NUButtonLabelModifier())
            }
            .padding(.trailing, 36)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CardHeaderView_Previews: PreviewProvider {
    @Namespace static var namespace
    static let cardType = CardType.eanButton
    
    static var previews: some View {
        CardHeaderView(cardType: cardType, namespace: namespace)
    }
}
