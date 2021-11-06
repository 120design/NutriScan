//
//  MockOFFService.swift
//  NutriScanTests
//
//  Created by Vincent Caronnet on 04/11/2021.
//

import Foundation
@testable import NutriScan

class MockOFFService: OFFServiceProtocol {
    var nuProduct: NUProduct? = nil
    var offError: OFFService.OFFError? = nil
    
    func getProduct(
        from eanCode: String,
        completion: @escaping (Result<NUProduct, OFFService.OFFError>) -> Void
    ) {
        if let offError = offError {
            completion(.failure(offError))
        } else if let nuProduct = nuProduct {
            completion(.success(nuProduct))
        }
    }
    
    func cancelRequest(with eanCode: String) {
        nuProduct = nil
        offError = .cancelledRequest
    }
}
