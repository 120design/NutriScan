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
        value: String,
        color: Color
    ) -> some View {
        Group {
            separatorView
            
            HStack {
                Text("\(title) :")
                    .font(nuProductDetailTextMediumItalicFont)
                Text(value)
                Spacer()
            }
            .font(nuProductDetailTextLightFont)
            .padding(.vertical, 4)
            .foregroundColor(color)
            .nuShadowTextModifier(color: color)
            .frame(maxWidth: .infinity)
        }
    }
    
    @ViewBuilder
    private var nutriscoreExplanation1: some View {
        VStack(alignment: .leading) {
            Text("Le Nutri-score attribue ")
                + Text("des points négatifs")
                .font(nuProductInfoTextBoldItalicFont)
                + Text(" et ")
                + Text("des points positifs")
                .font(nuProductInfoTextBoldItalicFont)
                + Text(" aux différents nutriments qui composent un aliment.")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(nuProductInfoTextFont)
        .foregroundColor(.nuSecondaryColor)
        .padding(.top, 5)
    }

    private let nutriscoreExplanation2Text = Text("Le score")
        .font(nuProductInfoTextBoldItalicFont)
        + Text(" est le nombre résultant de la différence entre les points négatifs et les points positifs. Ce score est ensuite traduit en une lettre allant de ")
        + Text("A pour les produits de meilleure qualité nutritionnelle")
        .font(nuProductInfoTextBoldItalicFont)
        + Text(" à ")
        + Text("E pour les produits de moins bonne qualité nutritionnelle.")
        .font(nuProductInfoTextBoldItalicFont)

    @ViewBuilder
    private var nutriscoreExplanation2: some View {
        VStack(alignment: .leading) {
            nutriscoreExplanation2Text
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(nuProductInfoTextFont)
        .foregroundColor(.nuSecondaryColor)
        .padding(.top, 5)
    }

    @ViewBuilder
    private var nutriscoreExplanation3: some View {
        VStack(alignment: .leading) {
            Text("Plus le score est bas, plus sa lettre se rapproche de A. Plus il élevé, plus sa lettre se rapproche du E.")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(nuProductInfoTextFont)
        .foregroundColor(.nuSecondaryColor)
        .padding(.top, 5)
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
                            value: getStringFrom(cgFloat: (getRounded(cgFloat: proteins_100g))),
                            color: .nuSenaryColor
                        )
                        
                        getInfoHstack(
                            title: "Glucides",
                            value: getStringFrom(cgFloat: (getRounded(cgFloat: carbohydrates_100g))),
                            color: .nuSeptenaryColor
                        )
                        
                        getInfoHstack(
                            title: "Lipides",
                            value: getStringFrom(cgFloat: (getRounded(cgFloat: fat_100g))),
                            color: .nuTertiaryColor
                        )
                        
                        getInfoHstack(
                            title: "Fibres",
                            value: getStringFrom(cgFloat: (getRounded(cgFloat: fiber_100g))),
                            color: .nuSecondaryColor
                        )
                        
                        getInfoHstack(
                            title: "Sel",
                            value: getStringFrom(cgFloat: (getRounded(cgFloat: salt_100g))),
                            color: .nuQuaternaryColor
                        )
                   }
                    .frame(maxWidth: .infinity)
                }
                .nuProductInfoCardModifier()
            }
            if let nutrisCore = product.nutriScore {
                VStack {
                    HStack(alignment: .top, spacing: 16.0) {
                        Image(nutrisCore.pictoName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 144)
                        
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text("Nutri-score")
                                    .nuProductDetailCardTitleModifier(color: .nuQuaternaryColor)
                                Spacer()
                            }
                            
                            getInfoHstack(
                                title: "Points positifs",
                                value: String(nutrisCore.positive_points),
                                color: .nuSecondaryColor
                            )
                            
                            getInfoHstack(
                                title: "Points négatifs",
                                value: String(nutrisCore.negative_points),
                                color: .nuTertiaryColor
                            )
                            
                            getInfoHstack(
                                title: "Score",
                                value: String(nutrisCore.score),
                                color: .nuQuaternaryColor
                            )
                       }
                        .frame(maxWidth: .infinity)
                    }
                    
                    nutriscoreExplanation1
                    nutriscoreExplanation2
                    nutriscoreExplanation3
                }
                .nuProductInfoCardModifier()
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


struct ProductInfoCard<Content: View>: View {
    let pictoView: Content
    let infosView: Content
    
    var body: some View {
        HStack(alignment: .top, spacing: 16.0) {
            pictoView
            infosView
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

//struct ProductNutrimentsInfoCard: View {
//    let nutriments: Nutriments
//
//    var proteins_100g: CGFloat {CGFloat(nutriments.proteins_100g ?? 0)}
//    var carbohydrates_100g: CGFloat {CGFloat(nutriments.carbohydrates_100g ?? 0)}
//    var fat_100g: CGFloat {CGFloat(nutriments.fat_100g ?? 0)}
//    var fiber_100g: CGFloat {CGFloat(nutriments.fiber_100g ?? 0)}
//    var salt_100g: CGFloat {CGFloat(nutriments.salt_100g ?? 0)}
//
//    var body: some View {
//        ProductInfoCard(pictoView: <#T##_#>, infosView: <#T##_#>)
//    }
//}
