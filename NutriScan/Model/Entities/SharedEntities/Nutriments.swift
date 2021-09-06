//
//  Nutriments.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 06/09/2021.
//

import Foundation

struct Nutriments: Decodable, Equatable {
//    static func ==(lhs: Nutriments, rhs: Nutriments) -> Bool {
//        return lhs.fiber_100g == rhs.fiber_100g
//            && lhs.carbohydrates_100g == rhs.carbohydrates_100g
//            && lhs.proteins_100g == rhs.proteins_100g
//            && lhs.fat_100g == rhs.fat_100g
//            && lhs.salt_100g == rhs.salt_100g
//    }
    
    let fiber_100g: Float?
    let carbohydrates_100g: Float?
    let proteins_100g: Float?
    let fat_100g: Float?
    let salt_100g: Float?
}
