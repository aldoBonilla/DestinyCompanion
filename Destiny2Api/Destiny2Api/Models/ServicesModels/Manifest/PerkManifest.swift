//
//  PerkManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct PerkManifest: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let display: DisplayManifest
    let isDisplayable: Bool
    let damageType: DamageType
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let displayManifest = try? DisplayManifest(dictionary: displayProp),
            let isDisplayable = dictionary["isDisplayable"] as? Bool,
            let damageTypeInt = dictionary["damageType"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.display = displayManifest
        self.isDisplayable = isDisplayable
        self.damageType = DamageType(rawValue: damageTypeInt) ?? .none
    }
    
    var description: String {
        return "Perk with name: \(display.name), isDisplayable: \(isDisplayable)"
    }
    
    var hashValue: Int {
        return hash.hashValue
    }
    
    static func == (lhs: PerkManifest, rhs: PerkManifest) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
