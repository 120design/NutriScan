//
//  NovaGroup.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

enum NovaGroup: Int, Decodable {
    case one = 1, two = 2, three = 3, four = 4
    
    var pictoName: String { "NovaGroup\(self.rawValue)" }
    
    var groupName: String { "Groupe \(self.rawValue)" }
    
    var caption: String {
        switch self {
        case .one:
            return "Aliment non transformé ou transformé minimalement"
        case .two:
            return "Ingrédient culinaire transformé"
        case .three:
            return "Aliment transformé"
        case .four:
            return "Produit alimentaire ou boisson ultra-transformé(e)"
        }
    }
}
