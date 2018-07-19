//
//  ItemManifestStatGroup.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ItemManifestStatGroup: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let disablePrimaryStatDisplay: Bool
    let stats: [String]
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statGroupHash"] as? Int,
              let disablePrimary = dictionary["disablePrimaryStatDisplay"] as? Bool,
              let statsDicts = dictionary["stats"] as? EntityDictionary else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key Value missing")
        }
        self.hash = hash
        self.disablePrimaryStatDisplay = disablePrimary
        self.stats = Array(statsDicts.keys)
    }
    
    var description: String {
        return "stat group hash: \(hash), number of stats: \(stats.count)"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: ItemManifestStatGroup, rhs: ItemManifestStatGroup) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
