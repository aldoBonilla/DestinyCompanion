//
//  Item.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

final class Item: CustomStringConvertible {
    
    let inventory: InventoryItem
    let instance: ItemInstance?
    let manifest: ItemManifest
    
    init(itemInventory: InventoryItem, itemInstance: ItemInstance? = nil, itemManifest: ItemManifest) {
        
        self.inventory = itemInventory
        self.instance = itemInstance
        self.manifest = itemManifest

    }
    
    var description: String {
        return "Item name: \(manifest.name)"
    }
    
}
