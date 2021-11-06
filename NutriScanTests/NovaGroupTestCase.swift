//
//  NovaGroupTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 06/11/2021.
//

import XCTest
@testable import NutriScan

class NovaGroupTestCase: XCTestCase {
    var sut: NovaGroup!
    
    func testGivenOneNovaGroup_WhenGetComputedProperties_ThenGoodValues() {
        // Given
        sut = .one
        
        // When
        
        // Then
        XCTAssertEqual(sut.pictoName, "NovaGroup1")
        XCTAssertEqual(sut.groupName, "Groupe 1")
        XCTAssertEqual(sut.caption, "Aliment non transformé ou transformé minimalement")
    }
    
    func testGivenTwoNovaGroup_WhenGetComputedProperties_ThenGoodValues() {
        // Given
        sut = .two
        
        // When
        
        // Then
        XCTAssertEqual(sut.pictoName, "NovaGroup2")
        XCTAssertEqual(sut.groupName, "Groupe 2")
        XCTAssertEqual(sut.caption, "Ingrédient culinaire transformé")
    }
    
    func testGivenThreeNovaGroup_WhenGetComputedProperties_ThenGoodValues() {
        // Given
        sut = .three
        
        // When
        
        // Then
        XCTAssertEqual(sut.pictoName, "NovaGroup3")
        XCTAssertEqual(sut.groupName, "Groupe 3")
        XCTAssertEqual(sut.caption, "Aliment transformé")
    }
    
    func testGivenFourNovaGroup_WhenGetComputedProperties_ThenGoodValues() {
        // Given
        sut = .four
        
        // When
        
        // Then
        XCTAssertEqual(sut.pictoName, "NovaGroup4")
        XCTAssertEqual(sut.groupName, "Groupe 4")
        XCTAssertEqual(sut.caption, "Produit alimentaire ou boisson ultra-transformé(e)")
    }
}
