//
//  ItemStatManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ItemStat: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let value: Int
    let maxValue: Int
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let value = dictionary["value"] as? Int,
              let maxValue = dictionary["maximumValue"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.value = value
        self.maxValue = maxValue
    }
    
    var description: String {
        return "Stat hash: \(hash), value: \(value), maxValue: \(maxValue)"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: ItemStat, rhs: ItemStat) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
    
}

