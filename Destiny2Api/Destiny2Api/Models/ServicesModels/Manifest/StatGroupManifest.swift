//
//  StatGroupManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct StatGroupManifest: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let uiPosition: Int
    let scaledStats: [ScaledStats]
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["statHash"] as? Int,
              let uiPosition = dictionary["uiPosition"] as? Int,
              let scaledStatsDicts = dictionary["scaledStats"] as? [EntityDictionary] else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key Value Missing")
        }
        
        self.hash = hash
        self.uiPosition = uiPosition
        self.scaledStats = ScaledStats.initEntities(dictionaries: scaledStatsDicts)
    }
    
    var description: String {
        return "Group position: \(uiPosition) with \(scaledStats.count) stats"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: StatGroupManifest, rhs: StatGroupManifest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
