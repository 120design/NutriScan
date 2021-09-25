//
//  File.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/09/2021.
//

import Foundation

struct EcoScore: Decodable, Equatable {
    struct Agribalyse: Decodable, Equatable {
        let score: Int
    }
    
    enum Grade: String, Decodable {
        case a = "a", b = "b", c = "c", d = "d", e = "e"
    }
    
    var pictoName: String {
        "EcoScore\(self.grade_value.rawValue.uppercased())"
    }
    
    struct Adjustments: Decodable, Equatable {
//        struct ProductionSystem: Decodable, Equatable, EmptyDictionaryRepresentable {
//            enum CodingKeys: String, CodingKey { case value }
//            let value: Int
//        }
//        struct OriginsOfIngredients: Decodable, Equatable, EmptyDictionaryRepresentable {
//            enum CodingKeys: String, CodingKey { case transportation_value, epi_value }
//            let transportation_value: Int
//            let epi_value: Int
//        }
//        struct Packaging: Decodable, Equatable, EmptyDictionaryRepresentable {
//            enum CodingKeys: String, CodingKey { case value }
//            let value: Int
//        }
//        struct ThreatenedSpecies: Decodable, Equatable, EmptyDictionaryRepresentable {
//            enum CodingKeys: String, CodingKey { case value }
//            var value: Int
//        }
//
//        private let production_system: ProductionSystem
//        private let origins_of_ingredients: OriginsOfIngredients
//        private let packaging: Packaging
//        private let threatened_species: ThreatenedSpecies
//
//        var production_system_value: Int? { production_system.value }
//        var transportation_value: Int? { origins_of_ingredients.transportation_value }
//        var epi_value: Int? { origins_of_ingredients.epi_value }
//        var packaging_value: Int? { packaging.value }
//        var threatened_species_value: Int? { threatened_species.value }
        
        struct ProductionSystem: Decodable, Equatable {
            let value: Int?
        }
        struct OriginsOfIngredients: Decodable, Equatable {
            let transportation_value: Int?
            let transportation_value_fr: Int?
            let epi_value: Int?
        }
        struct Packaging: Decodable, Equatable {
            let value: Int?
        }
        struct ThreatenedSpecies: Decodable, Equatable {
            var value: Int?
        }

        private let production_system: ProductionSystem
        private let origins_of_ingredients: OriginsOfIngredients
        private let packaging: Packaging
        private let threatened_species: ThreatenedSpecies

        var production_system_value: String {
            if let value = production_system.value {
                if value == 0 || value == 1 { return "+\(value) pt" }
                
                return "+ \(value) pts"
            }
            return "+0 pt"
        }

        var transportation_value: String {
            var value: Int?
            
            if let commonValue = origins_of_ingredients.transportation_value {
                value = commonValue
            }
            
            if let frenchValue = origins_of_ingredients.transportation_value_fr {
                value = frenchValue
            }
            
            if let value = value {
                if value == 0 || value == 1 { return "+\(value) pt" }
                
                return "+\(value) pts"
            }
            
            return "+0 pt"
        }

        var epi_value: String {
            if let value = origins_of_ingredients.epi_value {
                if value == 0 || value == 1 { return "+\(value) pt" }
                
                if value == -1 { return "\(value) pt" }
                
                if value == 1 { return "+\(value) pt" }
                
                if value < 1 { return "\(value) pts" }
                
                else { return "+\(value) pts" }
            }
            return "+0 pt"
        }

        var packaging_value: String {
            if let value = packaging.value {
                if value == 0 { return "-0 pt" }
                
                if value == -1 { return "\(value) pt" }
                
                return "\(value) pts"
            }
            return "-0 pt"
        }

        var threatened_species_value: String {
            if let value = threatened_species.value {
                if value == 0 { return "-0 pt" }
                
                if value == 1 { return "\(value) pt" }
                
                return "\(value) pts"
            }
            return "-0 pt"
        }
    }
    
    private let score: Int
    private let score_fr: Int?
    
    var score_value: String {
        var value = score
        
        if let score_fr = score_fr {
            value = score_fr
        }
        
        if (value == 0
            || value == 1
            || value == -1
        ) { return "\(value) pt/100" }
        
        return "\(value) pts/100"
    }
    
    private let grade: Grade
    private let grade_fr: Grade?
    
    var grade_value: Grade {
        var value = grade
        
        if let grade_fr = grade_fr { value = grade_fr }
        
        return value
    }
    
    private let agribalyse: Agribalyse
    
    var agribalyse_score: Int { agribalyse.score }
    let adjustments: Adjustments?
}
//"ecoscore_data": {
//    "agribalyse": {
//        "score": 55.5293581437332,
//        "agribalyse_ef_total": "0.61611724",
//        "agribalyse_food_name_en": "Biscuit (cookie), snack with dairy or vanilla filling",
//        "agribalyse_food_code": "24225",
//        "agribalyse_food_name_fr": "Goûter sec fourré (\"sandwiché\") parfum lait ou vanille"
//    },
//    "grade": "c",
//    "score": 40.5293581437332,
//    "status": "known",
//    "adjustments": {
//        "packaging": {
//            "packagings": [],
//            "value": 0,
//            "score": 100
//        },
//        "threatened_species": {
//            "value": -10,
//            "ingredient": "en:palm-oil"
//        },
//        "production_system": {},
//        "origins_of_ingredients": {
//            "value": -5,
//            "epi_value": -5,
//            "epi_score": 0,
//            "origins_from_origins_field": ["en:unknown"],
//            "aggregated_origins": [["en:unknown", 100]],
//            "transportation_score": 0,
//            "transportation_value": 0
//        }
//    }
//},
//    static func ==(lhs: Nutriments, rhs: Nutriments) -> Bool {
//        return lhs.fiber_100g == rhs.fiber_100g
//            && lhs.carbohydrates_100g == rhs.carbohydrates_100g
//            && lhs.proteins_100g == rhs.proteins_100g
//            && lhs.fat_100g == rhs.fat_100g
//            && lhs.salt_100g == rhs.salt_100g
//    }
