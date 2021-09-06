//
//  OFFService.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 27/12/2020.
//

import Foundation

struct OFFService {
    private let offApi = "https://world.openfoodfacts.org/api/v0/products/"
    
    // Création du singleton
    static let shared = OFFService()
    private init() {}
    
    enum OFFError: Error {
        case connection,
             undefined,
             response,
             statusCode,
             data,
             noProductFound
    }
    
    func getProduct(from eanCode: String, completion: @escaping (Result<NUProduct, OFFError>) -> Void) {
        let productURL = URL(string: offApi + eanCode)!
        let task = URLSession.shared.dataTask(with: productURL) { data, response, error in
            
            // HTTP request error handling
            if let error = error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    print("ERROR BECAUSE NOT CONNECTED TO INTERNET")
                    completion(.failure(.connection))
                    return
                } else {
                    print("UNDEFINED REQUEST ERROR")
                    completion(.failure(.undefined))
                    return
                }
            }
            
            // Getting HTTP response
            guard let response = response as? HTTPURLResponse else {
                print("ERROR WITH THE RESPONSE")
                completion(.failure(.response))
                return
            }
            guard response.statusCode == 200 else {
                print("ERROR WITH THE RESPONSE'S STATUS CODE", response.statusCode)
                completion(.failure(.statusCode))
                return
            }
            
            // Getting and decoding response's JSON data
            guard let data = data,
                  let offData = try? JSONDecoder().decode(OFFData.self, from: data)
            else {
                print("ERROR WITH THE DATA")
                completion(.failure(.data))
                return
            }
            
            // Checking than the response provide a product
            guard offData.status == 1,
                  let offProduct = offData.product
            else {
                print("NO PRODUCT FOUND")
                completion(.failure(.noProductFound))
                return
            }
            
            // Constructing a NUProduct's instance
            let id = offProduct._id
            
            let name = offProduct.product_name_fr ?? offProduct.product_name
            
            let nutriments = offProduct.nutriments
            
            let novaGroup = offProduct.nova_group
            
            let nutriScore = offProduct.nutriscore_grade ?? nil
            
            let image_url = offProduct.image_url ?? nil
            
            let product = NUProduct(
                id: id,
                name: name,
                imageURL: image_url,
                nutriments: nutriments,
                nutriScore: nutriScore,
                novaGroup: novaGroup
            )
            
            // Return the NUProduct
            completion(.success(product))
        }
        task.resume()
    }
}
