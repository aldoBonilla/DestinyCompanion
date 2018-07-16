//
//  ItemManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

struct ItemManifest: EntityProtocol, CustomStringConvertible {
    
    let about: String
    let name: String
    let icon: String?
    let color: UIColor?
    let screenshot: String?
    
    init(dictionary: EntityDictionary) throws {
        guard let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let about = displayProp["description"] as? String,
              let name = displayProp["name"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.about = about
        self.name = name
        self.icon = displayProp["icon"] as? String
        if let colorDict = dictionary["backgroundColor"] as? EntityDictionary { self.color = UIColor(dictionary: colorDict) } else { self.color = nil }
        self.screenshot = dictionary["screenshot"] as? String
    }
    
    var urlItemImage: URL? {
        if icon != nil {
            return URL(string: "\(Endpoint().bungieImages)\(icon!)")
        }
        return nil
        
    }

    var description: String {
        return "Item name: \(name)"
    }

    var dictionary: EntityDictionary {
        return [:]
    }
}
