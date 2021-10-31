//
//  File.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 19/09/2021.
//

import Foundation

struct EcoScore: Decodable, Equatable {
    struct Agribalyse: Decodable, Equatable {
        let score: Int?
    }
    
    enum Grade: String, Decodable {
        case a = "a", b = "b", c = "c", d = "d", e = "e"
    }
    
    var pictoName: String? {
        guard let grade_value = self.grade_value else { return nil }
        return "EcoScore\(grade_value.rawValue.uppercased())"
    }
    
    struct Adjustments: Decodable, Equatable {        
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

        let production_system: ProductionSystem?
        let origins_of_ingredients: OriginsOfIngredients?
        let packaging: Packaging?
        let threatened_species: ThreatenedSpecies?

        var production_system_value: String {
            if let value = production_system?.value {
                if value == 0 || value == 1 { return "+\(value) pt" }
                
                return "+ \(value) pts"
            }
            return "+0 pt"
        }

        var transportation_value: String {
            var value: Int?
            
            if let commonValue = origins_of_ingredients?.transportation_value {
                value = commonValue
            }
            
            if let frenchValue = origins_of_ingredients?.transportation_value_fr {
                value = frenchValue
            }
            
            if let value = value {
                if value == 0 || value == 1 { return "+\(value) pt" }
                
                return "+\(value) pts"
            }
            
            return "+0 pt"
        }

        var epi_value: String {
            if let value = origins_of_ingredients?.epi_value {
                if value == 0 || value == 1 { return "+\(value) pt" }
                
                if value == -1 { return "\(value) pt" }
                
                if value == 1 { return "+\(value) pt" }
                
                if value < 1 { return "\(value) pts" }
                
                else { return "+\(value) pts" }
            }
            return "+0 pt"
        }

        var packaging_value: String {
            if let value = packaging?.value {
                if value == 0 { return "-0 pt" }
                
                if value == -1 { return "\(value) pt" }
                
                return "\(value) pts"
            }
            return "-0 pt"
        }

        var threatened_species_value: String {
            if let value = threatened_species?.value {
                if value == 0 { return "-0 pt" }
                
                if value == 1 { return "\(value) pt" }
                
                return "\(value) pts"
            }
            return "-0 pt"
        }
    }
    
    let score: Int? // 41
    let score_fr: Int? // 36

    var score_value: String {
        var value = score ?? 0
        
        if let score_fr = score_fr {
            value = score_fr
        }
        
        if (value == 0
            || value == 1
            || value == -1
        ) { return "\(value) pt/100" }
        
        return "\(value) pts/100"
    }
    
    let grade: Grade? // .c
    let grade_fr: Grade? // .d
    
    var grade_value: Grade? {
        var value = grade
        
        if let grade_fr = grade_fr { value = grade_fr }
        
        return value
    }
    
    let agribalyse: Agribalyse?
    
    var agribalyse_score: Int { agribalyse?.score ?? 0 }
    let adjustments: Adjustments?
}
