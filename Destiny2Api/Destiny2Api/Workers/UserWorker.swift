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
        UserEndpoints.requestInfo(infoType: .character, forPlatform: CurrentSession.shared.userPlatform, userId: CurrentSession.shared.userMembership) { response, error in
            if let characterDictionaries = response {
                let characters: [Character] = Character.initEntities(dictionaries: characterDictionaries.getEntitiesDictionariesFromKeys())
                completion(characters, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getInvetoryItemsFrom(location: ItemLocationRequest, forCharacter character: String, _ completion: @escaping((_ inventoryItems: [InventoryItem]?, _ error: NSError?) -> Void)) {
        UserEndpoints.requestInfo(infoType: location.infoType, itemRequested: character, forPlatform: CurrentSession.shared.userPlatform, userId: CurrentSession.shared.userMembership) { response, error in
            if let responseDict = response,
               let itemDicts = responseDict["items"] as? [EntityDictionary] {
                    let items: [InventoryItem] = InventoryItem.initEntities(dictionaries: itemDicts)
                    completion(items, nil)
            } else {
                completion(nil, error)
            }
        }
    }

}
