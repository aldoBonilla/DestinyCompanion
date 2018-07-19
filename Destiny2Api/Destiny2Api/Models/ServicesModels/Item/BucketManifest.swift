//
//  ItemBucket.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 16/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ItemBucket: EntityProtocol, CustomStringConvertible, Hashable {
    
    let hash: Int
    let display: DisplayManifest
    let scope: Int
    let category: BucketCategory
    let order : Int
    let location: Int
    
    init(dictionary: EntityDictionary) throws {
        guard let hash = dictionary["hash"] as? Int,
              let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let displayManifest = try? DisplayManifest(dictionary: displayProp),
              let scope = dictionary["scope"] as? Int,
              let categoryInt = dictionary["category"] as? Int,
              let order = dictionary["buckerOrder"] as? Int,
              let location = dictionary["location"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.hash = hash
        self.display = displayManifest
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
        return "Bucket name: \(display.name)"
    }
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
