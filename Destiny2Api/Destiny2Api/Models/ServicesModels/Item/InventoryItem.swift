//
//  InventoryItem.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct InventoryItem: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let instance: String?
    let quantity: Int
    let location: ItemLocation
    let lockable: Bool
    let state: Int
    let bucketHash: Int
    
    init(dictionary: EntityDictionary) throws {
        
        guard let hash = dictionary["itemHash"] as? Int,
              let quantity = dictionary["quantity"] as? Int,
              let locationInt = dictionary["location"] as? Int,
              let lockable = dictionary["lockable"] as? Bool,
              let state = dictionary["state"] as? Int,
              let bucketHash = dictionary["bucketHash"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.instance = dictionary["itemInstanceId"] as? String
        self.quantity = quantity
        self.location = ItemLocation(rawValue: locationInt) ?? .unknown
        self.lockable = lockable
        self.state = state
        self.bucketHash = bucketHash
    }
    
    var description: String {
        return "Item hash: \(hash), instance: \(instance ?? "")"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: InventoryItem, rhs: InventoryItem) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
