//
//  Token.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation

struct Token: EntityProtocol, Decodable, CustomStringConvertible, Hashable {
    
    let expires_in: Double
    let refresh_token: String
    let access_token: String
    let refresh_expires_in: Double
    let membership_id: String
    
    init(dictionary: EntityDictionary) throws {
        
        guard let expiration = dictionary["expires_in"] as? Date,
            let refreshToken = dictionary["refresh_token"] as? String,
            let accessToken = dictionary["access_token"] as? String,
            let refreshExpiration = dictionary["refresh_expires_in"] as? Date,
            let membership = dictionary["membership_id"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        expires_in = expiration.timeIntervalSinceNow
        refresh_token = refreshToken
        access_token = accessToken
        refresh_expires_in = refreshExpiration.timeIntervalSinceNow
        membership_id = membership
    }
    
    var expires_date: Date {
        return Date().addingTimeInterval(expires_in)
    }
    
    var refresh_expires_date: Date {
        return Date().addingTimeInterval(refresh_expires_in)
    }
    
    var hashValue: Int {
        return access_token.hashValue
    }

    var description: String {
        return "Token with access: \(access_token) expires in: \(expires_date)"
    }

    static func ==(lhs: Token, rhs: Token) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var dictionary: EntityDictionary {
        return [
            "expires_in" : expires_date,
            "refresh_token" : refresh_token,
            "access_token" : access_token,
            "refresh_expires_in": refresh_expires_date,
            "membership_id": membership_id
        ]
    }
}
