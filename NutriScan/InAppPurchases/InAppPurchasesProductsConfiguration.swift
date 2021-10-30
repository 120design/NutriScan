//
//  InAppPurchasesProductsConfiguration.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 28/10/2021.
//

import Foundation

public struct InAppPurchasesProductsConfiguration {
    private init() {}
    
    static func readConfigFile() -> Set<ProductID>? {
        guard let result = InAppPurchasesProductsConfiguration.readPropertyFile(filename: "InAppPurchasesProducts"),
              let values = result["Products"] as? [String],
              result.count > 0
        else {
            return nil
        }
        
        return Set<ProductID>(values.compactMap { $0 })
    }
    
    private static func readPropertyFile(filename: String) -> [String : AnyObject]? {
        if let path = Bundle.main.path(forResource: filename, ofType: "plist") {
            if let contents = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
            {
                return contents
            }
        }
        
        return nil  // [:]
    }
}
