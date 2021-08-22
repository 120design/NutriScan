//
//  NUProduct.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

struct NUProduct: Equatable {
    let id: String
    let name: String
    let imageURL: String?
    let nutriScore: NutriScore?
    let novaGroup: NovaGroup?
}
