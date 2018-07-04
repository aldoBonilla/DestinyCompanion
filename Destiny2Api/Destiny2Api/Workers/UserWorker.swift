//
//  UserWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct UserWorker {
    
    static func basicCurrentUserInfo(_ completion: @escaping((_ user: User?,_ error: NSError?) -> Void)) {
        
        UserEndpoints.getCurrentPlayer() { userInfo, error in
            
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
}
