//
//  EmptyDictionaryRepresentable.swift
//  NutriScan
//
//  Created by Vincent Caronnet on 25/09/2021.
//

import Foundation

public protocol EmptyDictionaryRepresentable {
    associatedtype CodingKeys : RawRepresentable where CodingKeys.RawValue == String
    associatedtype CodingKeyType: CodingKey = Self.CodingKeys
}
extension KeyedDecodingContainer {
    // Given a nested object that is both optional, and explicitly allowed to be represented as an empty object `{}`, decode the object, or nil if
    // the underlying representation is `null` or `{}` in the payload
    public func decodeIfPresent<T>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T? where T : Decodable & EmptyDictionaryRepresentable {
        // First, check if the key exists at all, and if not return `nil` as is the default behavior
        if contains(key) {
            // Prepare to decode our nested object normally by opening a nested container
            let container = try nestedContainer(keyedBy: type.CodingKeyType.self, forKey: key)
            
            // If there are no "keys" in the set, the object is empty and we consider it to be `nil`
            if container.allKeys.isEmpty { return nil}
        } else { return nil }
        
        return try decode(T.self, forKey: key)
    }
}
