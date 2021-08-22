//
//  OFFData.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

struct OFFData: Decodable {
    struct OFFProduct: Decodable {
        struct OFFSelectedImages: Decodable {
            struct OFFImagesLanguages: Decodable {
                let fr: String?
                let en: String?
            }

            let selected_images: OFFImagesLanguages?
        }

        struct OFFNutriments: Decodable {
            private enum CodingKeys: String, CodingKey {
                case nova_group = "nova-group"
                case fiber_value
            }

            let fiber_value: Float?
            let nova_group: NovaGroup?
        }

        let _id: String
        let product_name: String
        let product_name_fr: String?
        let selectedImages: OFFSelectedImages?
        let nutriments: OFFNutriments?
        let nutriscore_grade: NutriScore?
        let image_url: String?
    }

    let status: Int
    let product: OFFProduct?
}
