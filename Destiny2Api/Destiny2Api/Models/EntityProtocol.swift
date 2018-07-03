//
//  EntityProtocol.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 13/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation

enum EntityNetworkingError: Error {
    case entityCantBeCreated(reason: String)
}

protocol EntityProtocol {
    
    init(dictionary: EntityDictionary) throws
    var dictionary: EntityDictionary { get }
    static func initEntities(dictionaries: [EntityDictionary]) -> [Self]
}

extension EntityProtocol {
    static func initEntities<T: EntityProtocol>(dictionaries: [EntityDictionary]) -> [T] {
        var entities = [T]()
        
        dictionaries.forEach { thisEntity in
            do {
                let entity = try T(dictionary: thisEntity)
                entities.append(entity)
            } catch {
                print("We couldnt proccess this module: \(thisEntity)")
                return
            }
        }
        return entities
    }
}

