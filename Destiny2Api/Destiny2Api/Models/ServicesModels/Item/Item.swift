//
//  Item.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct Item: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: String
    let location: ItemLocation
    let lockable: Bool
    let damageType: DamageType
    let stats: EntityDictionary
    let isEquipped: Bool
    let canEquip: Bool
    let equipRequiredLevel: Int
    let about: String
    let name: String
    let icon: String
    let color: (red: Int, green: Int, blue: Int, alpha: Int)
    let screenshot: String
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? String,
              let locationInt = dictionary["itemLocation"] as? Int,
              let lockable = dictionary["lockable"] as? Bool,
              let damageInt = dictionary["damageType"] as? Int,
              let stats = dictionary["stats"] as? EntityDictionary,
              let equipped = dictionary["isEquipped"] as? Bool,
              let canEquip = dictionary["canEquip"] as? Bool,
              let requiredLevel = dictionary["equipRequiredLevel"] as? Int,
              let about = dictionary["description"] as? String,
              let name = dictionary["name"] as? String,
              let icon = dictionary["icon"] as? String,
              let colorDict = dictionary["backgroundColor"] as? EntityDictionary,
              let screenshot = dictionary["screensho"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.location = ItemLocation(rawValue: locationInt) ?? .unknown
        self.lockable = lockable
        self.damageType = DamageType(rawValue: damageInt) ?? .none
        self.stats = stats
        self.isEquipped = equipped
        self.canEquip = canEquip
        self.equipRequiredLevel = requiredLevel
        self.about = about
        self.name = name
        self.icon = icon
        if let red = colorDict["red"] as? Int, let green = colorDict["green"] as? Int, let blue = ["blue"] as? Int, let alpha = colorDict["alpha"] as? Int {
            self.color = (red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.color = (red: 0, green: 0, blue: 0, alpha: 0)
        }
        self.screenshot = screenshot
        
    }
    
    var description: String {
        return "Item name: \(name)"
    }
    
    var hashValue: Int {
        return hash.hashValue
    }
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
