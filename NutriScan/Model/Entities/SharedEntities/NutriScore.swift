//
//  NutriScore.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

struct NutriScore: Decodable, Equatable {
    enum Grade: String, Decodable {
        case a = "a", b = "b", c = "c", d = "d", e = "e"
    }
    
    var pictoName: String? {
        guard let grade = self.grade else { return nil }
        return "NutriscoreLandscape\(grade.rawValue.uppercased())"
    }
    
    let score: Int?
    let negative_points: Int?
    let positive_points: Int?
    let grade: Grade?
}
