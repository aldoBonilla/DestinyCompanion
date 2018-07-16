//
//  ItemBucket.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 16/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum Buckets: Int {
    case kinectic
    case energy
    case power
    case ghost
    case helmet
    case gauntlets
    case chest
    case leg
    case classArmor
    case subclass
    case emblems
    case ships
    case emotes
    case clanBanner
    case mods
    case shaders
    
    var hash: Int {
        switch self {
        case .kinectic: return 1498876634
        case .energy: return 2465295065
        case .power: return 953998645
        case .ghost: return 4023194814
        case .helmet: return 3448274439
        case .gauntlets: return 3551918588
        case .chest: return 14239492
        case .leg: return 20886954
        case .classArmor: return 1585787867
        case .subclass: return 3284755031
        case .emblems: return 4274335291
        case .ships: return 284967655
        case .emotes: return 1107761855
        case .clanBanner: return 4292445962
        case .mods: return 3313201758
        case .shaders: return 2973005342
        }
    }
    
    var name: String {
        switch self {
        case .kinectic: return "Kinectic Weapons"
        case .energy: return "Energy Weapons"
        case .power: return "Power Weapons"
        case .ghost: return "Ghosts"
        case .helmet: return "Helmet"
        case .gauntlets: return "Gauntlets"
        case .chest: return "Chest Armor"
        case .leg: return "Leg Armor"
        case .classArmor: return "Class Armor"
        case .subclass: return "Subclass"
        case .emblems: return "Emblems"
        case .ships: return "Ships"
        case .emotes: return "Emotes"
        case .clanBanner: return "Clan Banner"
        case .mods: return "Modifications"
        case .shaders: return "Shaders"
        }
    }
}

enum ItemUICategory: Int {
    
    case weapon
    case armor
    case inventory
    
    var sections: [Buckets] {
    switch self {
    case .weapon: return [.kinectic, .energy, .power, .ghost]
    case .armor: return [.helmet, .gauntlets, .chest, .leg, .classArmor]
    case .inventory: return [.mods, .shaders, .ships]
    }
    }
    
}

struct ItemBucket: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let about: String
    let name: String
    let scope: Int
    let category: BucketCategory
    let order : Int
    let location: Int
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let about = displayProp["description"] as? String,
              let name = displayProp["name"] as? String,
              let scope = dictionary["scope"] as? Int,
              let categoryInt = dictionary["category"] as? Int,
              let order = dictionary["buckerOrder"] as? Int,
              let location = dictionary["location"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.about = about
        self.name = name
        self.scope = scope
        self.category = BucketCategory(rawValue: categoryInt) ?? .invisible
        self.order = order
        self.location = location
    }
    
    var hashValue: Int {
        return hash
    }
    
    static func == (lhs: ItemBucket, rhs: ItemBucket) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var description: String {
        return "Bucket name: \(name)"
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
