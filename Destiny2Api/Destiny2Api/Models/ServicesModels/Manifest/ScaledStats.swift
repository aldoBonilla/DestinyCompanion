//
//  ScaledStats.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ScaledStats: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let maxValue: Int
    let displayAsNumeric: Bool
    let displayInterpolations: [(value: Int, weight: Int)]
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let maxValue = dictionary["maximumValue"] as? Int,
              let displayAsNumeric = dictionary["displayAsNumeric"] as? Bool,
              let displayInterpolations = dictionary["displayInterpolation"] as? [EntityDictionary] else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        self.hash = hash
        self.maxValue = maxValue
        self.displayAsNumeric = displayAsNumeric
        var interpolations = [(value: Int, weight: Int)]()
        displayInterpolations.forEach { interpolationDict in
            if let value = interpolationDict["value"] as? Int,
                let weight = interpolationDict["weight"] as? Int {
                interpolations.append((value: value, weight: weight))
            }
        }
        self.displayInterpolations = interpolations
    }
    
    var description: String {
        return "Scaled Stat hash: \(hash), maxValue: \(maxValue), display as numeric: \(displayAsNumeric)"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: ScaledStats, rhs: ScaledStats) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
