//
//  ProductNutrimentsRingsView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 04/09/2021.
//

import SwiftUI

struct ProductNutrimentsRingsView: View {
    let proteins_100g: CGFloat
    let carbohydrates_100g: CGFloat
    let fat_100g: CGFloat
    let fiber_100g: CGFloat
    let salt_100g: CGFloat
    
    private func getSize(from factor: CGFloat) -> CGFloat {
        factor * pictureWidth / 100
    }

    var body: some View {
        ZStack {
            RingView(
                size: getSize(from: 92),
                percent: proteins_100g,
                color: .nuSenaryColor
            )
            RingView(
                size: getSize(from: 76),
                percent: carbohydrates_100g,
                color: .nuSeptenaryColor
            )
            RingView(
                size: getSize(from: 60),
                percent: fat_100g,
                color: .nuTertiaryColor
            )
            RingView(
                size: getSize(from: 44),
                percent: fiber_100g,
                color: .nuQuaternaryColor)
            RingView(
                size: getSize(from: 28),
                percent: salt_100g,
                color: .nuSecondaryColor
            )
        }
        .padding(getSize(from: 4))
    }
}

struct ProductCompositionRingsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductNutrimentsRingsView(
            proteins_100g: 10,
            carbohydrates_100g: 25,
            fat_100g: 15,
            fiber_100g: 14.6,
            salt_100g: 12
        )
        .background(Color.nuPrimaryColor)
    }
}
