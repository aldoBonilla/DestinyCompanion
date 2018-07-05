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
    
    static func getUserCharacters(_ completion: @escaping((_ characters: [Character]?,_ error: NSError?) -> Void )) {
        
        guard let platform = CurrentSession.shared.user?.platform, let userId = CurrentSession.shared.user?.id else {
            completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
            return
        }
        
        UserEndpoints.getUser(infoType: .character, forPlatform: platform, userId: userId) { userInfo, error in
            if userInfo != nil {
                guard let data = userInfo!["data"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                    return 
                }
                let keys = Array(data.keys)
                var characterDictionaries = [EntityDictionary]()
                keys.forEach { key in
                    if let thisDictionary = data[key] as? EntityDictionary {
                        characterDictionaries.append(thisDictionary)
                    }
                }
                let characters: [Character] = Character.initEntities(dictionaries: characterDictionaries)
                completion(characters, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
