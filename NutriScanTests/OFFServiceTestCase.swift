//
//  OFFServiceTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 31/10/2021.
//

import XCTest

@testable
import NutriScan

class OFFServiceTestCase: XCTestCase {
    var sut: OFFService!
    var expectation: XCTestExpectation!
    let timeOut = 1.0
    
    override func setUp() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession.init(configuration: configuration)
        
        sut = OFFService(
            session: session,
            offApi: MockResponseData.goodURL
        )
        expectation = expectation(description: "OFFServiceTestCase expectation")
    }
    
    func testGivenResponseAndDataAreCorrect_WhenGetProduct_ThenResponseIsASuccess() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.correctData
            )
        }
        
        // When
        sut.getProduct(from: "12345678") { result in
            print("OFFServiceTestCase ~> result ~>", result)
            
            // Then
            XCTAssertEqual(result, .success(MockResponseData.correctFoundProduct))
            
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeOut)
    }
}
