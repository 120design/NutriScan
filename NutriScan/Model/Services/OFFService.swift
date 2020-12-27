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

    enum OFFError {
        case connection, undefined, response, statusCode, data, noProductFound
    }

    func getProduct(from eanCode: String, completion: @escaping (OFFError?, NSProduct?) -> Void) {
        let productURL = URL(string: offApi + eanCode)!
        let task = URLSession.shared.dataTask(with: productURL) { data, response, error in

//            Traiter l’erreur de la requête HTTP
            if let error = error as? URLError {
                if error.code == URLError.Code.notConnectedToInternet {
                    print("ERROR BECAUSE NOT CONNECTED TO INTERNET")
                    completion(OFFError.connection, nil)
                    return
                } else {
                    print("UNDEFINED REQUEST ERROR")
                    completion(OFFError.undefined, nil)
                    return
                }
            }

//            Récupérer la réponse HTTP
            guard let response = response as? HTTPURLResponse else {
                print("ERROR WITH THE RESPONSE")
                completion(OFFError.response, nil)
                return
            }
            guard response.statusCode == 200 else {
                print("ERROR WITH THE RESPONSE'S STATUS CODE", response.statusCode)
                completion(OFFError.statusCode, nil)
                return
            }

//            Récupérer les données JSON de la réponse et les décoder
            guard let data = data, let offData = try? JSONDecoder().decode(OFFData.self, from: data) else {
                print("ERROR WITH THE DATA")
                completion(OFFError.data, nil)
                return
            }

//            Vérifier que l’EAN13 a retourné un produit enregistré dans la DB d’OFF
            guard offData.status == 1, let offProduct = offData.product else {
                print("NO PRODUCT FOUND")
                completion(OFFError.noProductFound, nil)
                return
            }

//            Construire une instance de NSProduct
            let id = offProduct._id

            var name = offProduct.product_name
            if let product_name_fr = offProduct.product_name_fr {
                name = product_name_fr
            }

            var novaGroup: NovaGroup? = nil
            if let nutriments = offProduct.nutriments {
                if let nova_group = nutriments.nova_group {
                    novaGroup = nova_group
                }
            }

            var nutriScore: NutriScore? = nil
            if let nutriscore_grade = offProduct.nutriscore_grade {
                nutriScore = nutriscore_grade
            }

            let product = NSProduct(
                id: id,
                name: name,
                imageURL: nil,
                nutriScore: nutriScore,
                novaGroup: novaGroup
            )

//            Tout s’est bien passé et la fermeture retourne une erreur nulle et un produit
            completion(nil, product)
        }
        task.resume()
    }
}
