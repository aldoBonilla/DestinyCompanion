//
//  ItemWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

class ItemWorker {
    
    static func getFullItems(_ character: Character, completion: @escaping((_ error: NSError?) ->Void)) {
    
        var equipmentFullItem = [Item]()
        
        character.equipment.forEach { inventoryItem in
            ItemWorker.getFullItem(inventoryItem) { item, error in
                if let equippedItem = item {
                    equipmentFullItem.append(equippedItem)
                    if equipmentFullItem.count == character.equipment.count {
                        character.equipmentFullItem = equipmentFullItem
                        if character.hasRetrievedAllHisItems == true {
                            completion(nil)
                        }
                    }
                }
            }
        }
        
        var inventoryFullItem = [Item]()
        
        character.inventory.forEach { inventoryItem in
            ItemWorker.getFullItem(inventoryItem) { item, error in
                if let equippedItem = item {
                    inventoryFullItem.append(equippedItem)
                    if inventoryFullItem.count == character.inventory.count {
                        character.inventoryFullItem = inventoryFullItem
                        if character.hasRetrievedAllHisItems == true {
                            completion(nil)
                        }
                    }
                }
            }
        }
    }
    
    
    static func getFullItem(_ itemInventory: InventoryItem, completion: @escaping((_ item: Item?, _ error: NSError?) -> Void )) {
        
        ItemWorker.getItemManifest("\(itemInventory.itemHash)") { itemManifest, error in
            
            if itemManifest != nil {
                if let instanceId = itemInventory.itemInstance {
                    ItemWorker.getItemInstance(instanceId) { instance, error in
                        if instance != nil {
                            let item = Item(itemInventory: itemInventory, itemInstance: instance!, itemManifest: itemManifest!)
                            completion(item, nil)
                        } else {
                            completion(nil, error)
                        }
                    }
                } else {
                    let item = Item(itemInventory: itemInventory, itemManifest: itemManifest!)
                    completion(item, nil)
                }
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    static func getItemManifest(_ hash: String, _ completion: @escaping((_ manifestItem: ItemManifest?, _ error: NSError?) -> Void )) {
        
        ManifestEndpoints.getContent(contentType: .itemBaseInfo, hash: hash) { response, error in
            if response != nil {
                do {
                    let item = try ItemManifest(dictionary: response!)
                    completion(item, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getItemInstance(_ item: String, _ completion: @escaping((_ inventoryItems: ItemInstance?, _ error: NSError?) -> Void)) {
        
        guard let platform = CurrentSession.shared.user?.platform, let userId = CurrentSession.shared.user?.id else {
            completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
            return
        }
        
        UserEndpoints.getUser(infoType: .itemBaseInfo, itemRequested: item,forPlatform: platform, userId: userId) { response, error in
            if response != nil {
                guard let data = response!["data"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                    return
                }
                
                do {
                    let item = try ItemInstance(dictionary: data)
                    completion(item, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
                
            } else {
                completion(nil, error)
            }
        }
    }
}
