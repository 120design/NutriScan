//
//  CardHeaderView.swift
//  CardHeaderView
//
//  Created by Vincent Caronnet on 16/08/2021.
//

import SwiftUI
import Kingfisher

struct CardHeaderImageView: View {
    let isProductImage: Bool
    let image: String
    
    var body: some View {
        Group {
            if isProductImage {
                KFImage.url(URL(string: image))
                    .nuCardHeaderImageModifier()
            } else {
                Image(systemName: image)
                    .nuCardHeaderImageModifier()
            }
        }
    }
}

struct CardHeaderView: View {
    let cardType: CardView.CardType
    
    @ViewBuilder
    private var imageView: some View {
        switch cardType {
        case .scanButton:
            Image(systemName: "barcode.viewfinder")
                .nuCardHeaderImageModifier()
        case .eanButton:
            Image(systemName: "textformat.123")
                .nuCardHeaderImageModifier()
        case .product(let product):
            KFImage.url(URL(string: product.imageURL ?? ""))
                .nuCardHeaderImageModifier()
        }
    }
    
    @ViewBuilder
    private var title: some View {
        switch cardType {
        case .scanButton:
            Text("Scanner un code à\u{00a0}barres")
        case .eanButton:
            Text("Taper un code EAN13 ou EAN8")
        case .product(let product):
            Text(product.name)
        }
    }
    
    var body: some View {
        return HStack(spacing: 12.0) {
            imageView
            VStack {
                title
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
    static let cardType = CardView.CardType.eanButton
    
    static var previews: some View {
        CardHeaderView(cardType: cardType)
    }
}
