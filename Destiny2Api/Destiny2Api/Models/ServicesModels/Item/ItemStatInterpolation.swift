//
//  ItemStatInterpolation.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ItemStatInterpolation: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let maxValue: Int
    let displayAsNumeric: Bool
    let statsInterpolation: [(value: Int, weight: Int)]
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let maxValue = dictionary["maximumValue"] as? Int,
              let displayAsNumeric = dictionary["displayAsNumeric"] as? Bool,
              let interpolationDicts = dictionary["displayInterpolation"] as? [EntityDictionary] else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.maxValue = maxValue
        self.displayAsNumeric = displayAsNumeric
        var statsInterpolation = [(value: Int, weight: Int)] ()
        interpolationDicts.forEach { interDict in
            if let value = interDict["value"] as? Int, let weight = interDict["weight"] as? Int {
                statsInterpolation.append((value: value, weight: weight))
            }
        }
        
        self.statsInterpolation = statsInterpolation
    }
    
    var description: String {
        return "Stat hash: \(hash), numeric: \(displayAsNumeric)"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: ItemStatInterpolation, rhs: ItemStatInterpolation) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
