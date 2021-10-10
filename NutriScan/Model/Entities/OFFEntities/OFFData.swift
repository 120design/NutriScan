//
//  OFFData.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

struct OFFData: Decodable {
    struct OFFProduct: Decodable {
        let _id: String
        let product_name: String
        let product_name_fr: String?
        let image_url: String?
        let nutriments: Nutriments?
        let nutriscore_data: NutriScore?
        let nova_group: NovaGroup?
        let ecoscore_data: EcoScore?
    }

    let status: Int
    let product: OFFProduct?
}
