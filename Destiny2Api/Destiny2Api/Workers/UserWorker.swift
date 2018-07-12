//
//  UserWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct UserWorker {
    
    static func basicCurrentUserInfo(_ completion: @escaping((_ error: NSError?) -> Void)) {
        
        UserEndpoints.getCurrentPlayer() { userInfo, error in
            
            if userInfo != nil {
                do {
                    let user = try User(dictionary: userInfo!)
                    CurrentSession.shared.update(user: user)
                    completion(nil)
                } catch {
                    completion(NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(error)
            }
            
        }
        
    }
    
    static func basicUserInfo(forPlatform platform: Int, username: String, completion: @escaping((_ user: User?,_ error: NSError?) -> Void )) {
        
        UserEndpoints.searchPlayer(forPlatform: platform, username: username) { userInfo, error in
            if userInfo != nil {
                do {
                    let user = try User(dictionary: userInfo!)
                    completion(user, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getUserCharacters(_ completion: @escaping((_ characters: [Character]?, _ error: NSError?) -> Void )) {
        
        guard let platform = CurrentSession.shared.user?.platform, let userId = CurrentSession.shared.user?.id else {
            completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
            return
        }
        
        UserEndpoints.getUser(infoType: .character, forPlatform: platform, userId: userId) { response, error in
            if response != nil {
                
                guard let characters = buildCharacters(response!) else {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                    return
                }
                
                completion(characters, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    private static func buildVault(_ dictionary: EntityDictionary) {
        
        guard let vaultDictionary = dictionary["profileInventory"] as? EntityDictionary, let vaultData = vaultDictionary["data"] as? EntityDictionary, let itemsData = vaultData["items"] as? [EntityDictionary] else {
            return
        }
        let vaultItems: [InventoryItem] = InventoryItem.initEntities(dictionaries: itemsData)
        CurrentSession.shared.update(vault: vaultItems)
        
    }
    
    private static func buildCharacters(_ dictionary: EntityDictionary) -> [Character]? {
        
        guard let charactersData = dictionary["characters"] as? EntityDictionary, let charactersEquipmentData = dictionary["characterEquipment"] as? EntityDictionary, let charactersInventoryData = dictionary["characterInventories"] as? EntityDictionary else {
            return nil
        }
        
        guard let characterDictionaries = charactersData["data"] as? EntityDictionary, let equipmentDictionaries = charactersEquipmentData["data"] as? EntityDictionary, let inventoryDictionaries = charactersInventoryData["data"] as? EntityDictionary else {
            return nil
        }
        
        var characters = [Character]()
        
        characterDictionaries.getEntitiesDictionariesFromKeys().forEach { dictionary in
            do {
                var thisCharacter = try Character(dictionary: dictionary)
                
                if let equipmentDict = equipmentDictionaries[thisCharacter.id] as? EntityDictionary, let itemsDictionaries = equipmentDict["items"] as? [EntityDictionary] {
                    let equipmentItems: [InventoryItem] = InventoryItem.initEntities(dictionaries: itemsDictionaries)
                    thisCharacter.equipment = equipmentItems
                }
                
                if let inventoryDict = inventoryDictionaries[thisCharacter.id] as? EntityDictionary, let itemsDictionaries = inventoryDict["items"] as? [EntityDictionary] {
                    let inventoryItems: [InventoryItem] = InventoryItem.initEntities(dictionaries: itemsDictionaries)
                    thisCharacter.inventory = inventoryItems
                }
                
                characters.append(thisCharacter)
                
            } catch {
                print("Could not build chracter")
            }
        }
        
        return characters
    }
    
    static func getCharacterInventory(_ character: String, _ completion: @escaping((_ inventoryItems: [InventoryItem]?, _ error: NSError?) -> Void)) {
        
        guard let platform = CurrentSession.shared.user?.platform, let userId = CurrentSession.shared.user?.id else {
            completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
            return
        }
        
        UserEndpoints.getUser(infoType: .characterInventories, itemRequested: character, forPlatform: platform, userId: userId) { response, error in
            if response != nil {
                guard let data = response!["data"] as? EntityDictionary, let itemsDicts = data["items"] as? [EntityDictionary] else {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                    return
                }
                
                let items: [InventoryItem] = InventoryItem.initEntities(dictionaries: itemsDicts)
                completion(items, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    
}
