//
//  ItemInstance.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

final class ItemInstance: EntityProtocol, CustomStringConvertible {
    
    let damageType: DamageType
    let primaryStat: ItemStat
    let level: Int
    let quality: Int
    let isEquipped: Bool
    let canEquip: Bool
    let equipRequiredLevel: Int
    
    init(dictionary: EntityDictionary) throws {
        guard let damageTypeInt = dictionary["damageType"] as? Int,
              let primaryStatDict = dictionary["primaryStat"] as? EntityDictionary,
              let primaryStat = try? ItemStat(dictionary: primaryStatDict),
              let level = dictionary["itemLevel"] as? Int,
              let quality = dictionary["quality"] as? Int,
              let isEquipped = dictionary["isEquipped"] as? Bool,
              let canEquip = dictionary["canEquip"] as? Bool,
              let requiredLevel = dictionary["equipRequiredLevel"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.damageType = DamageType(rawValue: damageTypeInt) ?? .none
        self.primaryStat = primaryStat
        self.level = level
        self.quality = quality
        self.isEquipped = isEquipped
        self.canEquip = canEquip
        self.equipRequiredLevel = requiredLevel
    }
    
    var description: String {
        return "Item level: \(level) light: \(primaryStat.value)"
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
