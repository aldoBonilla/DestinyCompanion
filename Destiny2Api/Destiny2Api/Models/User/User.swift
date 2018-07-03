//
//  User.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct User: EntityProtocol, Decodable, CustomStringConvertible, Hashable {
    
    var id: String
    var displayName: String
    var platform: Int
    
    init(dictionary: EntityDictionary) throws {
        guard let id = dictionary["membershipId"] as? String,
              let displayName = dictionary["displayName"] as? String,
              let platform =  dictionary["membershipType"] as? Int else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.id = id
        self.displayName = displayName
        self.platform = platform
    }
    
    var description: String {
        return "User with name: \(displayName)"
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [
            "membershipId": id,
            "displayName": displayName,
            "membershipType": platform
        ]
    }
}
