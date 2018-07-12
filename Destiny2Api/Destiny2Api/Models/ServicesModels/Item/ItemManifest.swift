//
//  ItemManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ItemManifest: EntityProtocol, CustomStringConvertible {
    
    let about: String
    let name: String
    let icon: String?
    let color: (red: Int, green: Int, blue: Int, alpha: Int)
    let screenshot: String
    
    init(dictionary: EntityDictionary) throws {
        guard let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let about = displayProp["description"] as? String,
              let name = displayProp["name"] as? String,
              let colorDict = dictionary["backgroundColor"] as? EntityDictionary,
              let red = colorDict["red"] as? Int,
              let green = colorDict["green"] as? Int,
              let blue = colorDict["blue"] as? Int,
              let alpha = colorDict["alpha"] as? Int,
              let screenshot = dictionary["screenshot"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.about = about
        self.name = name
        self.icon = displayProp["icon"] as? String
        self.color = (red: red, green: green, blue: blue, alpha: alpha)
        self.screenshot = screenshot
        
    }
    
    
    var description: String {
        return "Item name: \(name)"
    }
    
    
    var dictionary: EntityDictionary {
        return [:]
    }
}
