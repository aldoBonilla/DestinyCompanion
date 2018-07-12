//
//  ItemWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

class ItemWorker {
    
    
    static func getCharacterFullItemDescriptions(_ character: Character, completion: @escaping(() -> Void)) {
        
        let group = DispatchGroup()
        
        group.enter()
        ItemWorker.getFullItems(character.equipment) { fullItems in
            character.equipmentFullItem = fullItems
            group.leave()
        }
        
        group.enter()
        ItemWorker.getFullItems(character.inventory) { fullItems in
            character.inventoryFullItem = fullItems
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    static func getFullItems(_ items: [InventoryItem], completion: @escaping((_ fullItems: [Item]) ->Void)) {
    
        var fullItems = [Item]()
        
        let group = DispatchGroup()
        
        for inventoryItem in items {
            group.enter()
            ItemWorker.getFullItem(inventoryItem) { fullItem, error in
                if fullItem != nil {
                    fullItems.append(fullItem!)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion(fullItems)
        }
    }
    
    
    static func getFullItem(_ itemInventory: InventoryItem, completion: @escaping((_ item: Item?, _ error: NSError?) -> Void )) {
        
        var manifest: ItemManifest?
        var instance: ItemInstance?
        var error: NSError?
        
        let group = DispatchGroup()
        group.enter()
        ItemWorker.getItemManifest("\(itemInventory.itemHash)") { itemManifest, webError in
            manifest = itemManifest
            error = webError
            group.leave()
        }
        
        if let instanceId = itemInventory.itemInstance {
            group.enter()
            ItemWorker.getItemInstance(instanceId) { itemInstance, webError in
                instance = itemInstance
                error = webError
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if manifest != nil {
                let fullItem = Item(itemInventory: itemInventory, itemInstance: instance, itemManifest: manifest!)
                completion(fullItem, nil)
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
