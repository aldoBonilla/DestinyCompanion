//
//  UserEndpoints.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum UserMethods: EndpointConfiguration {
    
    case searchPlayer(platformType: Int, username: String)
    case profile(platformType: Int, id: String)
    case currentUserInfo
    
    var serverURL: String {
        return Endpoint().serverURL
    }
    
    var path: String {
        switch self {
        case .searchPlayer(let platform, let username): return "/SearchDestinyPlayer/\(platform)/\(username)"
        case .profile(let platform, let userid): return "/\(platform)/Profile/\(userid)/"
        case .currentUserInfo: return "/GetMembershipsForCurrentUser/"
        }
    }
    
    var fullPath: String {
        return "\(serverURL)/User\(path)"
    }
    
    var method: webMethod {
        return .GET
    }
    
    var parameters: BasicDictionary? {
        switch self {
        case .searchPlayer, .currentUserInfo: return nil
        case .profile: return ["components": "100"]
        }
    }
    
    var encoding: encoding? {
        return .url
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchPlayer, .profile: return [headerApiDestiny: destinyApiKey]
        case .currentUserInfo: return [headerApiDestiny: destinyApiKey, "Authorization": "Basic \(CurrentSession.shared.token!.access_token)", "oauth2": "ReadBasicUserProfile"]
        }
    }
}

struct UserEndpoints {
    
    static func getCurrentPlayer(completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        
        let currentPlayer = UserMethods.currentUserInfo
        
        WSAPI.shared.callService(url: currentPlayer.fullPath, method: currentPlayer.method, parameters: currentPlayer.parameters, param_Encoding: currentPlayer.encoding?.parameterEncoding, headers: currentPlayer.headers) { response, error in
            
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                
                //completion(userInfo, nil)
            }
            
        }
    }
    
    static func searchPlayer(forPlatform platform: Int, username: String, completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        
        let search = UserMethods.searchPlayer(platformType: platform, username: username)
            
        WSAPI.shared.callService(url: search.fullPath, method: search.method, parameters: search.parameters, param_Encoding: search.encoding?.parameterEncoding, headers: search.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let response = responseInfo["Response"] as? [EntityDictionary], let userInfo = response.first else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(userInfo, nil)
            }
        }
    }
    
    static func getProfile(forPlatform platform: Int, userId: String, completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        let profile = UserMethods.profile(platformType: platform, id: userId)
        WSAPI.shared.callService(url: profile.fullPath, method: profile.method, parameters: profile.parameters, param_Encoding: profile.encoding?.parameterEncoding, headers: profile.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let profile = responseInfo["Response"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(profile, nil)
            }
        }
        
    }
}
