//
//  ProductView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/08/2021.
//

import SwiftUI

struct ProductView: View {
    let product: NUProduct
    
    private func getStringFrom(cgFloat: CGFloat) -> String {
        "\(String(format: "%.1f", cgFloat).replacingOccurrences(of: ".", with: ",")) g/100g"
    }
    
    private var separatorView: some View {
        Capsule()
            .fill(Color.nuQuaternaryColor)
            .frame(height: 0.5)
            .nuShadowTextModifier(color: .nuQuaternaryColor)
    }
    
    private func getInfoHstack(
        title: String,
        value: CGFloat,
        color: Color
    ) -> some View {
        Group {
            separatorView
            
            HStack {
                Text("\(title) :")
                    .font(nuProductDetailTextMediumItalicFont)
                Text(getStringFrom(cgFloat: value))
                Spacer()
            }
            .font(nuProductDetailTextLightFont)
            .padding(.vertical, 4)
            .foregroundColor(color)
            .nuShadowTextModifier(color: color)
            .frame(maxWidth: .infinity)
        }
    }
    
    private func getRounded(cgFloat: CGFloat) -> CGFloat {
        round((cgFloat * 10) / 10)
    }
    
    var body: some View {
        ScrollView {
            if let nutriments = product.nutriments {
                let proteins_100g = CGFloat(nutriments.proteins_100g ?? 0)
                let carbohydrates_100g = CGFloat(nutriments.carbohydrates_100g ?? 0)
                let fat_100g = CGFloat(nutriments.fat_100g ?? 0)
                let fiber_100g = CGFloat(nutriments.fiber_100g ?? 0)
                let salt_100g = CGFloat(nutriments.salt_100g ?? 0)
                
                HStack(alignment: .top, spacing: 16.0) {
                    ProductNutrimentsRingsView(
                        proteins_100g: proteins_100g,
                        carbohydrates_100g: carbohydrates_100g,
                        fat_100g: fat_100g,
                        fiber_100g: fiber_100g,
                        salt_100g: round((salt_100g * 10) / 10)
                    )
                    VStack(alignment: .leading, spacing: 3) {
                        HStack {
                            Text("Nutriments")
                                .nuProductDetailCardTitleModifier(color: .nuQuaternaryColor)
                            Spacer()
                        }
                        
                        getInfoHstack(
                            title: "Protéines",
                            value: getRounded(cgFloat: proteins_100g),
                            color: .nuSenaryColor
                        )
                        
                        getInfoHstack(
                            title: "Glucides",
                            value: getRounded(cgFloat: carbohydrates_100g),
                            color: .nuSeptenaryColor
                        )
                        
                        getInfoHstack(
                            title: "Lipides",
                            value: getRounded(cgFloat: fat_100g),
                            color: .nuTertiaryColor
                        )
                        
                        getInfoHstack(
                            title: "Fibres",
                            value: getRounded(cgFloat: fiber_100g),
                            color: .nuSecondaryColor
                        )
                        
                        getInfoHstack(
                            title: "Sel",
                            value: getRounded(cgFloat: salt_100g),
                            color: .nuQuaternaryColor
                        )
                   }
                    .frame(maxWidth: .infinity)
                }
                .padding(10.0)
                .frame(maxWidth: .infinity)
                .background(Color.nuPrimaryColor)
                .nuSmoothCornersModifier()
                .nuShadowModifier(color: .nuPrimaryColor)
                .padding()
            }
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static let product = NUProduct(
        id: "1234",
        name: "Moutarde de Dijon",
        imageURL: "",
        nutriments: Nutriments(
            fiber_100g: 10,
            carbohydrates_100g: 8.5,
            proteins_100g: 8.5,
            fat_100g: 4.2,
            salt_100g: 25.12
        ),
        nutriScore: nil,
        novaGroup: nil
    )
    
    static var previews: some View {
        ProductView(product: product)
    }
}
