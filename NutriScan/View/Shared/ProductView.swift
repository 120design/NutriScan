//
//  ProductView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/08/2021.
//

import SwiftUI

struct ProductView: View {
    let product: NUProduct
    
    @Binding var parentIsDraggable: Bool
    
    private var viewHasContent: Bool {
        if let nutriments = product.nutriments {
            if nutriments.proteins_100g != nil
                || nutriments.carbohydrates_100g != nil
                || nutriments.fat_100g != nil
                || nutriments.fiber_100g != nil
                || nutriments.salt_100g != nil {
                return true
            }
            
            if nutriments.energy_kj_100g != nil
                || nutriments.energy_kcal_100g != nil {
                return true
            }
        }
        
        if let nutriScore = product.nutriScore,
           let _ = nutriScore.score,
           let _ = nutriScore.negative_points,
           let _ = nutriScore.positive_points,
           let _ = nutriScore.pictoName
        {
            return true
        }
        
        if let ecoScore = product.ecoScore,
           let _ = ecoScore.pictoName
        {
            return true
        }
        
        if let _ = product.novaGroup {
            return true
        }
        
        return false
    }
//    @State private var viewHasContent = false
    
    var body: some View {
        
        ScrollView {
            if viewHasContent {
                if let nutriments = product.nutriments {
                    if nutriments.proteins_100g != nil
                        || nutriments.carbohydrates_100g != nil
                        || nutriments.fat_100g != nil
                        || nutriments.fiber_100g != nil
                        || nutriments.salt_100g != nil {
                        ProductNutrimentsInformationsView(nutriments: nutriments)
                    }
                    
                    if nutriments.energy_kj_100g != nil
                        || nutriments.energy_kcal_100g != nil {
                        ProductEnergyInformationsView(
                            energy_kj_100g: nutriments.energy_kj_100g,
                            energy_kcal_100g: nutriments.energy_kcal_100g
                        )
                    }
                }
                
                if let nutriScore = product.nutriScore,
                   let score = nutriScore.score,
                   let negative_points = nutriScore.negative_points,
                   let positive_points = nutriScore.positive_points,
                   let pictoName = nutriScore.pictoName
                {
                    ProductNutriScoreInformationsView(
                        score: score,
                        negative_points: negative_points,
                        positive_points: positive_points,
                        pictoName: pictoName
                    )
                }
                
                if let ecoScore = product.ecoScore,
                   let pictoName = ecoScore.pictoName
                {
                    ProductEcoScoreInformationsView(ecoScore: ecoScore, pictoName: pictoName)
                }
                if let novaGroup = product.novaGroup {
                    ProductNovaGroupInformationsView(novaGroup: novaGroup)
                }

            } else {
                Text("La base de données d’Open Food Facts n’a pas fourni à NutriScan d’information nutritionnelle pour ce produit.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(nuBodyBookTextFont)
                    .foregroundColor(.nuPrimaryColor)
                    .padding([.leading, .trailing])
                    .padding(.bottom, 8)
            }
        }
        .gesture(
            DragGesture()
                .onChanged { _ in
                    self.parentIsDraggable = false
                }
                .onEnded { _ in
                    self.parentIsDraggable = true
                }
        )
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
            salt_100g: 25.12,
            energy_kj_100g: 100,
            energy_kcal_100g: 100
        ),
        nutriScore: nil,
        novaGroup: nil,
        ecoScore: nil
    )
    
    static var previews: some View {
        ProductView(product: product, parentIsDraggable: .constant(true))
    }
}

struct ProductInformationRowView: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        Capsule()
            .fill(Color.nuQuaternaryColor)
            .frame(height: 0.5)
            .nuShadowTextModifier(color: .nuQuaternaryColor)
        
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

struct ProductCardInformationsView<LeftContent: View, RightContent: View>: View {
    let cardTitle: String
    let leftContent: LeftContent
    let rightContent: RightContent
    let bottomContent: String?
    
    var body: some View {
        VStack {
            HStack(alignment: .top, spacing: 16.0) {
                VStack {
                    leftContent
                    
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(cardTitle)
                            .nuProductDetailCardTitleModifier(color: .nuQuaternaryColor)
                        Spacer()
                    }

                    rightContent
                }
                .frame(maxWidth: .infinity)
            }
            
            if let bottomContent = bottomContent {
                VStack(alignment: .leading) {
                    Text(bottomContent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)
            }
        }
        .font(nuProductInfoTextFont)
        .foregroundColor(.nuSecondaryColor)
        .nuProductInfoCardModifier()
    }
}

struct ProductNutrimentsInformationsView: View {
    let nutriments: Nutriments
    
    private func getStringFrom(cgFloat: CGFloat) -> String {
        "\(String(format: "%.1f", cgFloat).replacingOccurrences(of: ".", with: ",")) g/100g"
    }
    
    private func getRounded(cgFloat: CGFloat) -> CGFloat {
        round((cgFloat * 10) / 10)
    }
    
    var body: some View {
        let proteins_100g = CGFloat(nutriments.proteins_100g ?? 0)
        let carbohydrates_100g = CGFloat(nutriments.carbohydrates_100g ?? 0)
        let fat_100g = CGFloat(nutriments.fat_100g ?? 0)
        let fiber_100g = CGFloat(nutriments.fiber_100g ?? 0)
        let salt_100g = CGFloat(nutriments.salt_100g ?? 0)
        
        return ProductCardInformationsView(
            cardTitle: "Nutriments",
            
            leftContent: ProductNutrimentsRingsView(
                proteins_100g: proteins_100g,
                carbohydrates_100g: carbohydrates_100g,
                fat_100g: fat_100g,
                fiber_100g: fiber_100g,
                salt_100g: round((salt_100g * 10) / 10)
            ),
            
            rightContent: Group {
                ProductInformationRowView(
                    title: "Protéines",
                    value: getStringFrom(cgFloat: (getRounded(cgFloat: proteins_100g))),
                    color: .nuSenaryColor
                )
                
                ProductInformationRowView(
                    title: "Glucides",
                    value: getStringFrom(cgFloat: (getRounded(cgFloat: carbohydrates_100g))),
                    color: .nuSeptenaryColor
                )
                
                ProductInformationRowView(
                    title: "Lipides",
                    value: getStringFrom(cgFloat: (getRounded(cgFloat: fat_100g))),
                    color: .nuTertiaryColor
                )
                
                ProductInformationRowView(
                    title: "Fibres",
                    value: getStringFrom(cgFloat: (getRounded(cgFloat: fiber_100g))),
                    color: .nuQuaternaryColor
                )
                
                ProductInformationRowView(
                    title: "Sel",
                    value: getStringFrom(cgFloat: (getRounded(cgFloat: salt_100g))),
                    color: .nuSecondaryColor
                )
            },
            
            bottomContent: nil
        )
    }
}

struct ProductNutriScoreInformationsView: View {
    let score: Int
    let negative_points: Int
    let positive_points: Int
    let pictoName: String
    
    var body: some View {
        
        return ProductCardInformationsView(
            cardTitle: "Nutri-score",

            leftContent: Image(pictoName)
                .resizable()
                .scaledToFit()
                .frame(width: pictureWidth),
            
            rightContent: Group {
                ProductInformationRowView(
                    title: "Points négatifs",
                    value: String(negative_points),
                    color: .nuTertiaryColor
                )
                
                ProductInformationRowView(
                    title: "Points positifs",
                    value: String(positive_points),
                    color: .nuSecondaryColor
                )
                
                ProductInformationRowView(
                    title: "Score final",
                    value: "\(score) point\(score < -1 || score > 1 ? "s" : "")",
                    color: .nuQuaternaryColor
                )
            },
            
            bottomContent: "Le Nutri-score résulte de la différence entre ses points négatifs et ses points positifs. Plus il est bas, meilleures sont les qualités nutritionnelles du produit."
        )
    }
}

struct ProductEcoScoreInformationsView: View {
    let ecoScore: EcoScore
    let pictoName: String
    
    var body: some View {
        
        return ProductCardInformationsView(
            cardTitle: "Eco-score",

            leftContent: Image(pictoName)
                .resizable()
                .scaledToFit()
                .frame(width: pictureWidth),
            
            rightContent: Group {
                ProductInformationRowView(
                    title: "Score de départ",
                    value: "\(ecoScore.agribalyse_score) pts/100",
                    color: .nuTertiaryColor
                )
                
                ProductInformationRowView(
                    title: "Système de prod.",
                    value: "\(ecoScore.adjustments?.production_system_value ?? "+0 pt")",
                    color: .nuSecondaryColor
                )
                
                ProductInformationRowView(
                    title: "Transport",
                    value: "\(ecoScore.adjustments?.transportation_value ?? "+0 pt")",
                    color: .nuQuaternaryColor
                )
                
                ProductInformationRowView(
                    title: "Politique env.",
                    value: "\(ecoScore.adjustments?.epi_value ?? "+0 pt")",
                    color: .nuSenaryColor
                )
                
                ProductInformationRowView(
                    title: "Emballage",
                    value: "\(ecoScore.adjustments?.packaging_value ?? "-0 pt")",
                    color: .nuSeptenaryColor
                )
                
                ProductInformationRowView(
                    title: "Esp. menacées",
                    value: "\(ecoScore.adjustments?.threatened_species_value ?? "-0 pt")",
                    color: .nuTertiaryColor
                )
                
                ProductInformationRowView(
                    title: "Score final",
                    value: ecoScore.score_value,
                    color: .nuQuaternaryColor
                )
            },
            
            bottomContent: "Ce calcul de l’Eco-score est celui d’un produit consommé en France, le bonus accordé pour le transport pouvant varier d’un pays de consommation à un autre."
        )
    }
}

struct ProductEnergyInformationsView: View {
    let energy_kj_100g: Int?
    let energy_kcal_100g: Int?
    
    var body: some View {
        ProductCardInformationsView(
            cardTitle: "Énergie pour 100 g",

            leftContent: Image(systemName: "bolt.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: pictureWidth)
                .foregroundColor(.nuSecondaryColor),
            
            rightContent: Group {
                if let energy_kj_100g = energy_kj_100g {
                    ProductInformationRowView(
                        title: "Kilojoules",
                        value: "\(energy_kj_100g) kJ",
                        color: .nuSecondaryColor
                    )
                }
                
                if let energy_kcal_100g = energy_kcal_100g {
                    ProductInformationRowView(
                        title: "Kilocalories",
                        value: "\(energy_kcal_100g) kcal",
                        color: .nuTertiaryColor
                    )
                }
            },
            
            bottomContent: nil
        )
    }
}

struct ProductNovaGroupInformationsView: View {
    let novaGroup: NovaGroup
    
    var body: some View {
        ProductCardInformationsView(
            cardTitle: "Classification Nova",

            leftContent: Image(novaGroup.pictoName)
                .resizable()
                .scaledToFit()
                .frame(width: pictureWidth),
            
            rightContent: Group {
                Capsule()
                    .fill(Color.nuQuaternaryColor)
                    .frame(height: 0.5)
                    .nuShadowTextModifier(color: .nuQuaternaryColor)
                
                HStack {
                    Text("\(novaGroup.groupName) :")
                        .font(nuProductDetailTextMediumItalicFont)
                    Spacer()
                }
                .padding(.top, 4)
                .nuShadowTextModifier(color: .nuSecondaryColor)
                .frame(maxWidth: .infinity)
                
                HStack {
                    Text(novaGroup.caption)
                    Spacer()
                }
                .font(nuProductDetailTextLightFont)
                .padding(.top, 2)
                .nuShadowTextModifier(color: .nuSecondaryColor)
                .frame(maxWidth: .infinity)
            }
                .foregroundColor(.nuSecondaryColor),
            
            bottomContent: nil
        )
    }
}
