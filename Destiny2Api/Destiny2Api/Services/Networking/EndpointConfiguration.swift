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
    case itemBaseInfo
    case equipmentSlot
    case itemBucket
    
    var componentValue: String {
        switch self {
        case .profileVault: return "102"
        case .character: return "102, 200, 201, 205"
        case .characterInventories: return "201"
        case .characterEquipment: return "205"
        case .itemBaseInfo: return "300"
        default: return ""
        }
    }
    
    var keyword: String {
        switch self {
        case .character: return "characters"
        case .characterInventories: return "inventory"
        case .itemBaseInfo: return "instance"
        default: return ""
        }
    }
    
    var additionalPath: String {
        switch self {
        case .characterEquipment, .characterInventories: return "Character/"
        case .itemBaseInfo: return "Item/"
        default:
            return ""
        }
    }
    
    var manifestEntity: String {
        
        switch self {
        case .itemBaseInfo: return "DestinyInventoryItemDefinition/"
        case .equipmentSlot: return "DestinyEquipmentSlotDefinition/"
        case .itemBucket: return "DestinyInventoryBucketDefinition/"
        default: return ""
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
        //return "https://www.bungie.net/Platform/Destiny2"
    }
    
    var bungieImages: String {
        return "https://www.bungie.net"
    }
}
