//
//  StatsWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct StatsWorker {
    
    static func getDetailStats(_ instanceId: String, group: Int, _ completion: @escaping((_ stats: [StatUI]) -> Void )) {
        
        StatsWorker.getStatsFor(instanceId) { itemStats, error in
            if itemStats != nil {
                StatsWorker.arrangeStats(itemStats!, group: group) { statsUI in
                    completion(statsUI)
                }
            } else {
                completion([])
            }
        }
    }
    
    static func getStatsFor(_ instanceId: String, _ completion: @escaping((_ stats: [ItemStat]?, _ error: NSError?) -> Void )) {
        
        UserEndpoints.requestInfo(infoType: .itemInstanceStats, itemRequested: instanceId, forPlatform:  CurrentSession.shared.userPlatform, userId:  CurrentSession.shared.userMembership) { response, error in
            if let statsData = response, let statsDict = statsData["stats"] as? EntityDictionary {
                let statDicts = statsDict.getEntitiesDictionariesFromKeys()
                let stats: [ItemStat] = ItemStat.initEntities(dictionaries: statDicts)
                completion(stats, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func arrangeStats(_ stats: [ItemStat], group: Int, _ completion: @escaping((_ stats: [StatUI]) -> Void )) {
        
        var statsUI = [StatUI]()
        ManifestWorker.getManifestFor(type: .statGroup, hash: group) { (statGroup: StatGroupManifest?, error) in
            if statGroup != nil {
                let dispatchGroup = DispatchGroup()
                stats.forEach { stat in
                    if let numeric = statGroup!.scaledStats.filter({ $0.hash == stat.hash }).first?.displayAsNumeric {
                        dispatchGroup.enter()
                        StatsWorker.getStatUI(stat, numeric: numeric) { statUI, error in
                            if statUI != nil {
                                statsUI.append(statUI!)
                            }
                            dispatchGroup.leave()
                        }
                    }
                }
            } else {
                completion(statsUI)
            }
        }
    }
    
    static func getStatUI(_ itemStat: ItemStat, numeric: Bool, _ completion: @escaping((_ perk: StatUI?, _ error: NSError?) -> Void )) {
        
        ManifestWorker.getManifestDisplayProperties(type: .stat, hash: itemStat.hash) { displayProp, error in
            if displayProp != nil {
                let statUI = StatUI(name: displayProp!.name, value: itemStat.value, maxValue: itemStat.maxValue, isNumeric: numeric)
                completion(statUI, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }
    
}
