//
//  CharacterEnums.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 04/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum CharacterRace: Int {
    
    case human
    case awoken
    case exo
    case unknown
    
    var description: String {
        switch self {
        case .human: return "Human"
        case .awoken: return "Awoken"
        case .exo: return "Exo"
        default: return "Unknown"
        }
    }
    
}

enum CharacterClass: Int {
    
    case titan
    case hunter
    case warlock
    case unknown
    
    var description: String {
        switch self {
        case .titan: return "Titan"
        case .hunter: return "Hunter"
        case .warlock: return "warlock"
        default: return "Unknown"
        }
    }
}
