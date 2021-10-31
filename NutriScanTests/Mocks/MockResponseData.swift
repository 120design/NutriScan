//
//  MockResponseData.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 31/10/2021.
//

import Foundation

@testable
import NutriScan

class MockResponseData {
    // MARK: - Simulate URL
    
    static let goodURL = "https://www.apple.com/fr/"
    static let badURL = "bad url"
    
    // MARK: - Simulate response
    static let responseOK = HTTPURLResponse(
        url: URL(string: goodURL)!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: [:]
    )!
    static let responseKO = HTTPURLResponse(
        url: URL(string: goodURL)!,
        statusCode: 500,
        httpVersion: nil,
        headerFields: [:]
    )!
    static let responseWithBadURL = HTTPURLResponse(
        url: URL(string: badURL)!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: [:]
    )!
    static let responseWithConnectionError = HTTPURLResponse(
        url: URL(string: badURL)!,
        statusCode: 200,
        httpVersion: nil,
        headerFields: [:]
    )!

    // MARK: - Simulata error
    class FakeResponseDataError: Error {}
    static let error = FakeResponseDataError()
    static let internetConnectionError = URLError(.notConnectedToInternet)
    static let undefinedError = URLError(.cannotFindHost)

    // MARK: - Simulate data
    static var correctData: Data? {
        let bundle = Bundle(for: MockResponseData.self)
        let url = bundle.url(forResource: "3502110006790-jus-d-orange-tropicana", withExtension: "json")!
        return try! Data(contentsOf: url)
    }
    static var correctFoundProduct = NUProduct(
        id: "3502110006790",
        name: "Tropicana Pure premium orange sans pulpe format familial 1,5 L",
        imageURL: Optional("https://images.openfoodfacts.org/images/products/350/211/000/6790/front_fr.64.400.jpg"),
        nutriments: Optional(
            Nutriments(
                fiber_100g: Optional(0.6),
                carbohydrates_100g: Optional(8.9),
                proteins_100g: Optional(0.8),
                fat_100g: Optional(0),
                salt_100g: Optional(0),
                energy_kj_100g: Optional(182),
                energy_kcal_100g: Optional(43)
            )
        ),
        nutriScore: Optional(
            NutriScore(
                score: Optional(3),
                negative_points: Optional(13),
                positive_points: Optional(10),
                grade: Optional(.c)
            )
        ),
        novaGroup: Optional(.one),
        ecoScore: Optional(
            EcoScore(
                score: Optional(41),
                score_fr: Optional(36),
                grade: Optional(.c),
                grade_fr: Optional(.d),
                agribalyse: Optional(EcoScore.Agribalyse(score: Optional(51))),
                adjustments: Optional(
                    EcoScore.Adjustments(
                        production_system: EcoScore.Adjustments.ProductionSystem(value: nil),
                        origins_of_ingredients: EcoScore.Adjustments.OriginsOfIngredients(
                            transportation_value: nil,
                            transportation_value_fr: Optional(0),
                            epi_value: Optional(-5)
                        ),
                        packaging: Optional(EcoScore.Adjustments.Packaging(value: -10)),
                        threatened_species: EcoScore.Adjustments.ThreatenedSpecies(value: nil)
                    )
                )
            )
        )
    )

    static let incorrectData = "incorrect data".data(using: .utf8)!
}
