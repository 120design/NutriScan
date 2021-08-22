//
//  ProductView.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 21/08/2021.
//

import SwiftUI

struct ProductView: View {
    let product: NUProduct
    
    var body: some View {
        VStack {
            Text(product.name)
            Spacer()
        }
    }
}

struct ProductView_Previews: PreviewProvider {
    static let product = NUProduct(
        id: "1234",
        name: "Moutarde de Dijon",
        imageURL: "",
        nutriScore: nil,
        novaGroup: nil
    )
    
    static var previews: some View {
        ProductView(product: product)
    }
}
