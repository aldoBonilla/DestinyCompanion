//
//  GeneralDisplayManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct DisplayManifest: EntityProtocol, CustomStringConvertible {
    
    let name: String
    let about: String
    let icon: String?
    
    init(dictionary: EntityDictionary) throws {
        guard let name = dictionary["name"] as? String,
              let about = dictionary["description"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        self.name = name
        self.about = about
        self.icon = dictionary["icon"] as? String
    }
    
    var description: String {
        return "Name: \(name), about: \(about)"
    }
    
    var iconPath: URL? {
        if icon != nil {
            return URL(string: "\(Endpoint().bungieImages)\(icon!)")
        }
        return nil
    }
    
    var dictionary: EntityDictionary {
        return [
            "name": name,
            "description": about,
            "icon": icon
        ]
    }
}
