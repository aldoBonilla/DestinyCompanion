//
//  WSEndpointsProtocol.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation

enum UserInfoType {
    
    case profileVault
    case character
    case characterInventories
    case characterEquipment
    case itemInstance
    case itemInstancePerks
    case itemInstanceStats
    
    var componentValue: String {
        switch self {
        case .profileVault: return "102"
        case .character: return "200"
        case .characterInventories: return "201"
        case .characterEquipment: return "205"
        case .itemInstance: return "300"
        case .itemInstancePerks: return "302"
        case .itemInstanceStats: return "304"
        }
    }
    
    var keyword: String {
        switch self {
        case .profileVault: return "profileInventory"
        case .character: return "characters"
        case .characterInventories: return "inventory"
        case .characterEquipment: return "equipment"
        case .itemInstance: return "instance"
        case .itemInstancePerks: return "perks"
        case .itemInstanceStats: return "stats"
        }
    }
    
    var additionalPath: String {
        switch self {
        case .characterEquipment, .characterInventories: return "Character/"
        case .itemInstance, .itemInstancePerks, .itemInstanceStats: return "Item/"
        default:
            return ""
        }
    }
    
    var privacyLvl: Int {
        switch self {
        case .character, .characterEquipment, .itemInstance, .itemInstancePerks, .itemInstanceStats: return 1
        case .profileVault, .characterInventories: return 2
        }
    }
}

enum ItemLocationRequest {
    case vault
    case equipment
    case inventory
    
    var infoType: UserInfoType {
        switch self {
        case .vault: return .profileVault
        case .equipment: return .characterEquipment
        case .inventory: return .characterInventories
        }
    }
}


protocol EndpointConfiguration {
    var serverURL: String { get }
    var path: String { get }
    var fullPath: String { get }
    var method: webMethod { get }
    var parameters: BasicDictionary? { get }
    var encoding: encoding? { get }
    var headers: [String: String]? { get }
}

struct Endpoint {
    
    var serverURL: String {
        return "https://www.bungie.net/platform"
    }
    
    var bungieImages: String {
        return "https://www.bungie.net"
    }
}
