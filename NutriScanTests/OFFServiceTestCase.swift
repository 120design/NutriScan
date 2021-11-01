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
    
    func testGivenResponseAndDataAreCorrect_WhenGetProduct_ThenResultIsSuccess() {
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
            
            // Then
            XCTAssertEqual(result, .success(MockResponseData.correctFoundProduct))
            
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenBadURL_WhenGetProduct_ThenResultIsUndefinedFailure() {
        // Given
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let session = URLSession.init(configuration: configuration)

        sut = OFFService(
            session: session,
            offApi: MockResponseData.badURL
        )

        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.undefined))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenRequestHasConnectionError_WhenGetProduct_ThenResultIsConnectionFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: MockResponseData.internetConnectionError,
                response: nil,
                data: nil
            )
        }
        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.connection))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
    
    func testGivenBadResponseData_WhenGetProduct_ThenResultIsIncorrectDataFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.incorrectData
            )
        }
        
        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.data))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenNoResponseData_WhenGetProduct_ThenResultIsDataFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: nil
            )
        }
        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.data))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenBadStatusResponse_WhenGetProduct_ThenResultIsStatusCodeFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseKO,
                data: nil
            )
        }

        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.statusCode))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenNoResponse_WhenGetProduct_ThenResultIsResponseFailure() {
        // Giventm
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: nil,
                data: nil
            )
        }

        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.response))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenNoProductFound_WhenGetProduct_ThenResultIsNoProductFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.noProductFound
            )
        }

        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.noProductFound))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenUndefinedError_WhenGetProduct_ThenResultUndefinedFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: URLError(.unknown),
                response: MockResponseData.responseOK,
                data: MockResponseData.correctData
            )
        }

        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            XCTAssertEqual(result, .failure(.undefined))
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenNoPictureDataNorNameFR_WhenGetProduct_ThenPictureIsNilAndNameIsName() {
        // Giventm
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.incompleteData
            )
        }

        // When
        sut.getProduct(from: "12345678") { result in
            // Then
            var imageURL: String? = ""
            var name = ""
            
            switch result {
            case .success(let product):
                imageURL = product.imageURL
                name = product.name
            case .failure(_):
                break
            }
            
            XCTAssertNil(imageURL)
            XCTAssertEqual(name, "English Name")
            
            self.expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenGetProduct_WhenRequestCancelled_ThenNilRequestAndResultIsCancelFailure() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.correctData
            )
        }

        let eanCode = "12345678"
        sut.getProduct(from: eanCode) { result in
            // Then
            XCTAssertEqual(result, .failure(.cancelledRequest))
        }
        
        // When
        sut.cancelRequest(with: eanCode)
        
        // Then
        let url  = URL(string: MockResponseData.goodURL + eanCode)!
        
        var currentTask: URLSessionTask?

        sut.session.getAllTasks { tasks in
            currentTask = tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == url }
                .first
            
            self.expectation.fulfill()
            XCTAssertNil(currentTask)
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenGetProductL_WhenAnotherRequestCancelled_ThenNotNilRequest() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.correctData
            )
        }

        let eanCode = "12345678"
        let anotherEANCode = "1234"
        sut.getProduct(from: eanCode) { result in }
        
        // When
        sut.cancelRequest(with: anotherEANCode)
        
        // Then
        let currentTaskURL = URL(string: MockResponseData.goodURL + eanCode)!

        var currentTask: URLSessionTask?

        sut.session.getAllTasks { tasks in
            currentTask = tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == currentTaskURL }
                .first
            
            self.expectation.fulfill()
            XCTAssertNotNil(currentTask)
        }
        
        wait(for: [expectation], timeout: timeOut)
    }

    func testGivenGetProduct_WhenRequestCancelledWithBadURL_ThenNotNilRequest() {
        // Given
        MockURLProtocol.requestHandler = { request in
            return (
                error: nil,
                response: MockResponseData.responseOK,
                data: MockResponseData.correctData
            )
        }
        
        let eanCode = "12345678"
        sut.getProduct(from: eanCode) { result in }
        
        // When
        sut.cancelRequest(with: "bad ean with withespaces")
        
        // Then
        let currentTaskURL = URL(string: MockResponseData.goodURL + eanCode)!

        var currentTask: URLSessionTask?

        sut.session.getAllTasks { tasks in
            currentTask = tasks
                .filter { $0.state == .running }
                .filter { $0.originalRequest?.url == currentTaskURL }
                .first
            
            self.expectation.fulfill()
            XCTAssertNotNil(currentTask)
        }
        
        wait(for: [expectation], timeout: timeOut)
    }
}
