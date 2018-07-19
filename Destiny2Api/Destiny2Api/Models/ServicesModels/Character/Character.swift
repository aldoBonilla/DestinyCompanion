//
//  Character.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 04/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import UIKit

struct Character: EntityProtocol, CustomStringConvertible, Hashable {
    
    let id: String
    let light: Int
    let raceType: CharacterRace
    let classType: CharacterClass
    let emblemPath: String
    let emblemBackgroundPath: String
    let emblemColor: UIColor?
    let level: Int
    let percentToNextLevel: Double
    
    init(dictionary: EntityDictionary) throws {
        guard let id = dictionary["characterId"] as? String,
              let light = dictionary["light"] as? Int,
              let raceRaw = dictionary["raceType"] as? Int,
              let classRaw = dictionary["classType"] as? Int,
              let emblem = dictionary["emblemPath"] as? String,
              let emblemBackground = dictionary["emblemBackgroundPath"] as? String,
              let level = dictionary["baseCharacterLevel"] as? Int,
              let progression = dictionary["percentToNextLevel"] as? Double else {
                throw EntityNetworkingError.entityCantBeCreated(reason: "Key value missing")
        }
        
        self.id = id
        self.light = light
        self.raceType = CharacterRace(rawValue: raceRaw) ?? .unknown
        self.classType = CharacterClass(rawValue: classRaw) ?? .unknown
        self.emblemPath = emblem
        self.emblemBackgroundPath = emblemBackground
        if let colorDict = dictionary["emblemColor"] as? EntityDictionary { self.emblemColor = UIColor(dictionary: colorDict) } else { self.emblemColor = nil }
        self.level = level
        self.percentToNextLevel = progression
    }
    
    var description: String {
        return "Character class: \(classType), with light: \(light)"
    }
    
    var hashValue: Int {
        return id.hashValue
    }
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    var urlBannerBackground: URL? {
        return URL(string: "\(Endpoint().bungieImages)\(emblemBackgroundPath)")
    }
    
    var dictionary: EntityDictionary {
        return [
            "characterId": id,
            "light": light,
            "raceType": raceType.rawValue,
            "classType": classType.rawValue,
            "emblemPath": emblemPath,
            "emblemBackgroundPath": emblemBackgroundPath,
            "baseCharacterLevel": level,
            "percentToNextLevel": percentToNextLevel
        ]
    }
}
