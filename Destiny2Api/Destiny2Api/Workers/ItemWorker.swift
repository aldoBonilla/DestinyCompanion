//
//  ItemWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 09/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

class ItemWorker {
    
    static func orderBucketsFor(category: ItemUICategory, withItems items: [ItemUI]) -> [(name: String, sectionItems: [ItemUI])] {
        
        var uiSections = [(name: String, sectionItems: [ItemUI])]()
        
        category.sections.forEach { section in
            let sectionItems = items.filter({$0.inventory.bucketHash == section.rawValue})
            let thisUISection = (name: section.name, sectionItems:sectionItems)
            uiSections.append(thisUISection)
        }
        
        return uiSections
    }
    
    static func getItemsFor(characterId: String, completion: @escaping((_ items: [ItemUI]) -> Void)) {
        
        var equipementItems = [ItemUI]()
        var inventoryItems = [ItemUI]()
        
        let group = DispatchGroup()
        group.enter()
//        UserWorker.getInvetoryItemsFrom(location: .equipment, forCharacter: characterId) { items, error in
//            if items != nil {
//                getFullItems(items!) { uiItems in
//                    equipementItems = uiItems
//                    group.leave()
//                }
//            } else {
//                group.leave()
//            }
//        }
//
//        group.enter()
        UserWorker.getInvetoryItemsFrom(location: .inventory, forCharacter: characterId) { items, error in
            if items != nil {
                getFullItems(items!) { uiItems in
                    inventoryItems = uiItems
                    group.leave()
                }
            } else {
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let totalItems = equipementItems + inventoryItems
            completion(totalItems)
        }
    }
    
    static func getFullItems(_ items: [InventoryItem], completion: @escaping((_ fullItems: [ItemUI]) ->Void)) {
    
        var fullItems = [ItemUI]()
        let group = DispatchGroup()
        
        for inventoryItem in items {
            group.enter()
            ItemWorker.getItemUI(inventoryItem) { fullItem, error in
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
    
    
    static func getItemUI(_ itemInventory: InventoryItem, completion: @escaping((_ item: ItemUI?, _ error: NSError?) -> Void )) {
        
        var manifest: ItemManifest?
        var instance: ItemInstance?
        var error: NSError?
        
        let group = DispatchGroup()
        group.enter()
        
        ManifestWorker.getManifestFor(type: .item, hash: itemInventory.hash) { (entity: ItemManifest?, workerError) in
            manifest = entity
            error = workerError
            group.leave()
        }
        
        if let instanceId = itemInventory.instance {
            group.enter()
            ItemWorker.getItemInstance(instanceId) { itemInstance, webError in
                instance = itemInstance
                error = webError
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if manifest != nil {
                let fullItem = ItemUI(itemInventory: itemInventory, itemInstance: instance, itemManifest: manifest!)
                completion(fullItem, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getItemInstance(_ instanceId: String, _ completion: @escaping((_ inventoryItems: ItemInstance?, _ error: NSError?) -> Void)) {
        
        UserEndpoints.requestInfo(infoType: .itemInstance, itemRequested: instanceId, forPlatform: CurrentSession.shared.userPlatform, userId: CurrentSession.shared.userMembership) { response, error in
            
            if let instanceDict = response {
                do {
                    let item = try ItemInstance(dictionary: instanceDict)
                    completion(item, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
            
        }
    }
    
    static func getPerksUIFor(_ instanceId: String, _ completion: @escaping((_ perks: [PerkUI]) -> Void )) {
        ItemWorker.getPerksFor(instanceId) { wsPerks, error in
            if wsPerks != nil {
                let visiblePerks = wsPerks!.filter { $0.visible == true }
                let group = DispatchGroup()
                var uiPerks = [PerkUI]()
                visiblePerks.forEach { perk in
                    group.enter()
                    getPerkUI(perk) { perkUI, error in
                        if perkUI != nil {
                            uiPerks.append(perkUI!)
                        }
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(uiPerks)
                }
            } else {
                completion([])
            }
        }
    }
    
    static func getPerkUI(_ itemPerk: ItemPerk, _ completion: @escaping((_ perk: PerkUI?, _ error: NSError?) -> Void )) {
        
        ManifestWorker.getManifestFor(type: .perk, hash: itemPerk.hash) { (manifest: PerkManifest?, error) in
            if manifest != nil {
                let perkUI = PerkUI(name: manifest!.display.name, about: manifest!.display.about, icon: itemPerk.icon)
                completion(perkUI, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
    static func getPerksFor(_ instanceId: String, _ completion: @escaping((_ perks: [ItemPerk]?, _ error: NSError?) -> Void )) {
        
        UserEndpoints.requestInfo(infoType: .itemInstancePerks, itemRequested: instanceId, forPlatform:  CurrentSession.shared.userPlatform, userId:  CurrentSession.shared.userMembership) { response, error in
            if let perksData = response, let perksDicts = perksData["perks"] as? [EntityDictionary] {
                let perks: [ItemPerk] = ItemPerk.initEntities(dictionaries: perksDicts)
                completion(perks, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
