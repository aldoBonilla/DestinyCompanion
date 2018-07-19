//
//  Item.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ItemUI: CustomStringConvertible {
    
    let inventory: InventoryItem
    let instance: ItemInstance?
    let manifest: ItemManifest
    
    init(itemInventory: InventoryItem, itemInstance: ItemInstance? = nil, itemManifest: ItemManifest) {
        
        self.inventory = itemInventory
        self.instance = itemInstance
        self.manifest = itemManifest

    }
    
    var description: String {
        return "Item name: \(manifest.display.name)"
    }
}

struct PerkUI {
    
    let icon: String
    let name: String
    let about: String
    
    init(name: String, about: String, icon: String) {
        self.name = name
        self.about = about
        self.icon = icon
    }
    
    var perkIcon: URL? {
        return URL(string: "\(Endpoint().bungieImages)\(icon)")
    }
}

struct StatUI {
    
    let name: String
    let value: Int
    let maxValue: Int
    let isNumeric: Bool
    
    init(name: String, value: Int, maxValue: Int, isNumeric: Bool) {
        self.name = name
        self.value = value
        self.maxValue = maxValue
        self.isNumeric = isNumeric
    }
}


