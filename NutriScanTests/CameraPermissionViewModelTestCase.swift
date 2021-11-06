//
//  CameraPermissionViewModelTestCase.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 01/11/2021.
//

import XCTest
@testable import NutriScan
import AVFoundation

class CameraPermissionViewModelTestCase: XCTestCase {
    var sut: CameraPermissionViewModel!
    var expectation: XCTestExpectation!
    let timeOut = 2.0
    
    override func setUp() {
        super.setUp()
        
        expectation = expectation(description: "OFFServiceTestCase expectation")
    }
    
    override func tearDown() {
        sut = nil
        expectation = nil
        
        super.tearDown()
    }
    
    func testGivenAccesGrantedIsFalse_WhenRequestAccessReturnsTrue_ThenAccessGrantedIsTrue() {
        // Given
        sut = CameraPermissionViewModel(
            requestAccess: requestMethod
        )

        sut.requestPermission()
        
        func requestMethod(
            for: AVMediaType,
            completionHander: @escaping ((Bool) -> Void)
        ) {
            // When
            completionHander(true)
            
            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
                XCTAssertTrue(self.sut.accessGranted)
                self.expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: timeOut)
   }
    
    func testGivenAccesGrantedIsFalse_WhenRequestAccessReturnsFalse_ThenAccessGrantedIsFalse() {
        // Given
        func requestMethod(
            for: AVMediaType,
            completionHander: @escaping ((Bool) -> Void)
        ) {
            // When
            completionHander(false)
            
            // Then
            DispatchQueue.main.asyncAfter(deadline: .now() + timeOut / 2) {
                XCTAssertFalse(self.sut.accessGranted)
                self.expectation.fulfill()
            }
        }
        sut = CameraPermissionViewModel(
            requestAccess: requestMethod
        )

        sut.requestPermission()

        wait(for: [expectation], timeout: timeOut)
   }
}
