//
//  File.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/09/2021.
//

import Foundation

struct EcoScore: Decodable, Equatable {
    enum Grade: String, Decodable {
        case a = "a", b = "b", c = "c", d = "d", e = "e"
    }
    
    var pictoName: String {
        "EcoScore\(self.grade.rawValue.uppercased())"
    }
    
    let grade: Grade
}
