//
//  NSProduct.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

struct NSProduct {
    let id: String
    let name: String
    let imageURL: URL?
    let nutriScore: NutriScore?
    let novaGroup: NovaGroup?
}
