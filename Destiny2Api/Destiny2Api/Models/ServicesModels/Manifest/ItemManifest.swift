//
//  ItemManifest.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

struct ItemManifest: EntityProtocol, CustomStringConvertible {

    let display: DisplayManifest
    let typeName: String
    let icon: String?
    let color: UIColor?
    let screenshot: String?
    let statsGroupHash: Int?
    
    init(dictionary: EntityDictionary) throws {
        guard let displayProp = dictionary["displayProperties"] as? EntityDictionary,
              let displayManifest = try? DisplayManifest(dictionary: displayProp),
              let typeName = dictionary["itemTypeDisplayName"] as? String else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.display = displayManifest
        self.typeName = typeName
        self.icon = displayProp["icon"] as? String
        if let colorDict = dictionary["backgroundColor"] as? EntityDictionary { self.color = UIColor(dictionary: colorDict) } else { self.color = nil }
        self.screenshot = dictionary["screenshot"] as? String
        if let statsDict = dictionary["stats"] as? EntityDictionary, let groupHash = statsDict["statGroupHash"] as? Int { self.statsGroupHash = groupHash } else { self.statsGroupHash = nil }
    }
    
    var urlScreenshot: URL? {
        if screenshot != nil {
            return URL(string: "\(Endpoint().bungieImages)\(screenshot!)")
        }
        return nil
    }

    var description: String {
        return "Item name: \(display.name)"
    }

    var dictionary: EntityDictionary {
        return [:]
    }
}
