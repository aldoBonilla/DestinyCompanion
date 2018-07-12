//
//  Item.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

final class Item: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let location: ItemLocation
    let lockable: Bool
    let damageType: DamageType?
    let primaryStatValue: Int?
    let isEquipped: Bool?
    let canEquip: Bool?
    let equipRequiredLevel: Int?
    let about: String
    let name: String
    let icon: String?
    let color: (red: Int, green: Int, blue: Int, alpha: Int)
    let screenshot: String
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let locationInt = dictionary["itemLocation"] as? Int,
              let lockable = dictionary["lockable"] as? Bool,
              let about = dictionary["description"] as? String,
              let name = dictionary["name"] as? String,
              let colorDict = dictionary["backgroundColor"] as? EntityDictionary,
              let screenshot = dictionary["screensho"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.location = ItemLocation(rawValue: locationInt) ?? .unknown
        self.lockable = lockable
        if let damageInt = dictionary["damageType"] as? Int { self.damageType = DamageType(rawValue: damageInt) } else { self.damageType = nil }
        if let primaryStat = dictionary["primaryStat"] as? EntityDictionary, let value = primaryStat["value"] as? Int { self.primaryStatValue = value } else { self.primaryStatValue = nil }
        self.isEquipped = dictionary["isEquipped"] as? Bool
        self.canEquip = dictionary["canEquip"] as? Bool
        self.equipRequiredLevel = dictionary["equipRequiredLevel"] as? Int
        self.about = about
        self.name = name
        self.icon = dictionary["icon"] as? String
        if let red = colorDict["red"] as? Int, let green = colorDict["green"] as? Int, let blue = colorDict["blue"] as? Int, let alpha = colorDict["alpha"] as? Int {
            self.color = (red: red, green: green, blue: blue, alpha: alpha)
        } else {
            self.color = (red: 0, green: 0, blue: 0, alpha: 0)
        }
        self.screenshot = screenshot
        
    }
    
    init(itemInventory: InventoryItem, itemInstance: ItemInstance? = nil, itemManifest: ItemManifest) {
        
        self.hash = itemInventory.itemHash
        self.location = itemInventory.location
        self.lockable = itemInventory.lockable
        self.damageType = itemInstance?.damageType
        self.primaryStatValue = itemInstance?.primaryStatValue
        self.isEquipped = itemInstance?.isEquipped
        self.canEquip = itemInstance?.canEquip
        self.equipRequiredLevel = itemInstance?.equipRequiredLevel
        self.about = itemManifest.about
        self.name = itemManifest.name
        self.icon = itemManifest.icon
        self.color = itemManifest.color
        self.screenshot = itemManifest.screenshot
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
