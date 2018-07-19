//
//  ItemPerk.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

final class ItemPerk: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let icon: String
    let isActive: Bool
    let visible: Bool
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["perkHash"] as? Int,
              let icon = dictionary["iconPath"] as? String,
              let active = dictionary["isActive"] as? Bool,
              let visible = dictionary["visible"] as? Bool else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.icon = icon
        self.isActive = active
        self.visible = visible
    }
    
    var description: String {
        return "Perk with Hash: \(hash)"
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: ItemPerk, rhs: ItemPerk) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var perkIcon: URL? {
        return URL(string: "\(Endpoint().bungieImages)\(icon)")
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
