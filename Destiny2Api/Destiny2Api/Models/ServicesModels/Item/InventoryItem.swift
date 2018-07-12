//
//  InventoryItem.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct InventoryItem: EntityProtocol, CustomStringConvertible, Hashable {
    
    let itemHash: Int
    let itemInstance: String?
    let quantity: Int
    let location: ItemLocation
    let lockable: Bool
    let state: Int
    
    init(dictionary: EntityDictionary) throws {
        
        guard let hash = dictionary["itemHash"] as? Int,
              let quantity = dictionary["quantity"] as? Int,
              let locationInt = dictionary["location"] as? Int,
              let lockable = dictionary["lockable"] as? Bool,
              let state = dictionary["state"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.itemHash = hash
        self.itemInstance = dictionary["itemInstanceId"] as? String
        self.quantity = quantity
        self.location = ItemLocation(rawValue: locationInt) ?? .unknown
        self.lockable = lockable
        self.state = state
    }
    
    
    
    var description: String {
        return "Item hash: \(itemHash)"
    }
    
    var hashValue: Int {
        return itemHash.hashValue
    }
    
    static func == (lhs: InventoryItem, rhs: InventoryItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
