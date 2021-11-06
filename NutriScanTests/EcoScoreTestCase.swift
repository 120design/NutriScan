//
//  EcoScoreTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 06/11/2021.
//

import XCTest
@testable import NutriScan

class EcoScoreTestCase: XCTestCase {
    var sut: EcoScore!
    
    func testGivenNilValues_WhenGetComputedProperties_ThenNilValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: nil
        )
        
        // When
        
        // Then
        XCTAssertNil(sut.pictoName)
        XCTAssertNil(sut.score_fr)
        XCTAssertEqual(sut.score_value, "0 pt/100")
        XCTAssertNil(sut.grade_fr)
        XCTAssertNil(sut.grade_value)
        XCTAssertEqual(sut.agribalyse_score, 0)
    }
    
    func testGivenGradeFR_WhenGetComputedProperties_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: .b,
            grades: EcoScore.Grades(fr: .a),
            agribalyse: nil,
            adjustments: nil
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.pictoName, "EcoScoreA")
        XCTAssertEqual(sut.grade_value, .a)
    }
    
    func testGivenScoreFR_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: 0,
            scores: EcoScore.Scores(fr: 1),
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: nil
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.score_value, "1 pt/100")
    }
    
    func testGivenNegativeScore_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: -1,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: nil
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.score_value, "-1 pt/100")
    }
    
    func testGivenPositiveScore_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: 2,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: nil
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.score_value, "2 pts/100")
    }
    
    func testGivenAdjustmentsValues1_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: EcoScore.Adjustments(
                production_system: EcoScore.Adjustments.ProductionSystem(value: 0),
                origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                    transportation_value: nil,
                    transportation_values: EcoScore.Adjustments.OriginsOfIngredients.TransportationValues(fr: 1),
                    epi_value: 0
                ),
                packaging: EcoScore.Adjustments.Packaging(value: 0),
                threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: 0)
            )
        )
        
        // When
        
        // Then
        XCTAssertEqual(sut.adjustments?.origins_of_ingredients?.transportation_value_fr, 1)
        XCTAssertEqual(sut.adjustments?.production_system_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.transportation_value, "+1 pt")
        XCTAssertEqual(sut.adjustments?.epi_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.packaging_value, "-0 pt")
        XCTAssertEqual(sut.adjustments?.threatened_species_value, "-0 pt")
    }
    
    func testGivenAdjustmentsValues2_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: EcoScore.Adjustments(
                production_system: EcoScore.Adjustments.ProductionSystem(value: 1),
                origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                    transportation_value: 2,
                    transportation_values: nil,
                    epi_value: -1
                ),
                packaging: EcoScore.Adjustments.Packaging(value: -1),
                threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: 1)
            )
        )
        
        // When
        
        // Then
        XCTAssertNil(sut.adjustments?.origins_of_ingredients?.transportation_value_fr)
        XCTAssertEqual(sut.adjustments?.production_system_value, "+1 pt")
        XCTAssertEqual(sut.adjustments?.transportation_value, "+2 pts")
        XCTAssertEqual(sut.adjustments?.epi_value, "-1 pt")
        XCTAssertEqual(sut.adjustments?.packaging_value, "-1 pt")
        XCTAssertEqual(sut.adjustments?.threatened_species_value, "1 pt")
    }
    
    func testGivenAdjustmentsValues3_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: EcoScore.Adjustments(
                production_system: EcoScore.Adjustments.ProductionSystem(value: 0),
                origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                    transportation_value: 0,
                    transportation_values: nil,
                    epi_value: 1
                ),
                packaging: EcoScore.Adjustments.Packaging(value: -2),
                threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: -2)
            )
        )
        
        // When
        
        // Then
        XCTAssertNil(sut.adjustments?.origins_of_ingredients?.transportation_value_fr)
        XCTAssertEqual(sut.adjustments?.production_system_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.transportation_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.epi_value, "+1 pt")
        XCTAssertEqual(sut.adjustments?.packaging_value, "-2 pts")
        XCTAssertEqual(sut.adjustments?.threatened_species_value, "-2 pts")
    }
    
    func testGivenAdjustmentsValues4_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: EcoScore.Adjustments(
                production_system: EcoScore.Adjustments.ProductionSystem(value: 2),
                origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                    transportation_value: nil,
                    transportation_values: nil,
                    epi_value: -2
                ),
                packaging: EcoScore.Adjustments.Packaging(value: nil),
                threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: nil)
            )
        )
        
        // When
        
        // Then
        XCTAssertNil(sut.adjustments?.origins_of_ingredients?.transportation_value_fr)
        XCTAssertEqual(sut.adjustments?.production_system_value, "+2 pts")
        XCTAssertEqual(sut.adjustments?.transportation_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.epi_value, "-2 pts")
        XCTAssertEqual(sut.adjustments?.packaging_value, "-0 pt")
        XCTAssertEqual(sut.adjustments?.threatened_species_value, "-0 pt")
    }
    
    func testGivenAdjustmentsValues5_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: EcoScore.Adjustments(
                production_system: EcoScore.Adjustments.ProductionSystem(value: nil),
                origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                    transportation_value: nil,
                    transportation_values: nil,
                    epi_value: 2
                ),
                packaging: EcoScore.Adjustments.Packaging(value: nil),
                threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: nil)
            )
        )
        
        // When
        
        // Then
        XCTAssertNil(sut.adjustments?.origins_of_ingredients?.transportation_value_fr)
        XCTAssertEqual(sut.adjustments?.production_system_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.transportation_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.epi_value, "+2 pts")
        XCTAssertEqual(sut.adjustments?.packaging_value, "-0 pt")
        XCTAssertEqual(sut.adjustments?.threatened_species_value, "-0 pt")
    }
    
    func testGivenAdjustmentsValues6_WhenGetComputedProperty_ThenGoodValues() {
        // Given
        sut = EcoScore(
            score: nil,
            scores: nil,
            grade: nil,
            grades: nil,
            agribalyse: nil,
            adjustments: EcoScore.Adjustments(
                production_system: EcoScore.Adjustments.ProductionSystem(value: nil),
                origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                    transportation_value: nil,
                    transportation_values: nil,
                    epi_value: nil
                ),
                packaging: EcoScore.Adjustments.Packaging(value: nil),
                threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: nil)
            )
        )
        
        // When
        
        // Then
        XCTAssertNil(sut.adjustments?.origins_of_ingredients?.transportation_value_fr)
        XCTAssertEqual(sut.adjustments?.production_system_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.transportation_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.epi_value, "+0 pt")
        XCTAssertEqual(sut.adjustments?.packaging_value, "-0 pt")
        XCTAssertEqual(sut.adjustments?.threatened_species_value, "-0 pt")
    }
}
