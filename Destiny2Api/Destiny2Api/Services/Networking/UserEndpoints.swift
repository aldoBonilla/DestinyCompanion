//
//  UserEndpoints.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 17/01/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum UserInfoType: Int {
    
    case profileVault = 102
    case character = 200
    case characterInventories = 201
    case characterActivities = 204
    
    var keyword: String {
        switch self {
        case .character: return "characters"
        default: return ""
        }
    }
}


enum UserMethods: EndpointConfiguration {
    
    case searchPlayer(platformType: Int, username: String)
    case infoRequest(platformType: Int, id: String, infoType: UserInfoType)
    case currentUserInfo
    
    var serverURL: String {
        return Endpoint().serverURL
    }
    
    var path: String {
        switch self {
        case .searchPlayer(let platform, let username): return "/SearchDestinyPlayer/\(platform)/\(username)"
        case .infoRequest(let platform, let userid, _): return "/Destiny2/\(platform)/Profile/\(userid)/"
        case .currentUserInfo: return "/User/GetMembershipsForCurrentUser/"
        }
    }
    
    var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    var method: webMethod {
        return .GET
    }
    
    var parameters: BasicDictionary? {
        switch self {
        case .searchPlayer, .currentUserInfo: return nil
        case .infoRequest( _, _, let requestType): return ["components": "\(requestType.rawValue)"]
        }
    }
    
    var encoding: encoding? {
        return .url
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchPlayer, .infoRequest: return [headerApiDestiny: destinyApiKey]
        case .currentUserInfo: return [headerApiDestiny: destinyApiKey, "Authorization": "Bearer \(CurrentSession.shared.token!.access_token)"]
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
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let responseObjects = responseInfo["Response"] as? EntityDictionary, let memberships = responseObjects["destinyMemberships"] as? [EntityDictionary], let thisMembership = memberships.first else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(thisMembership, nil)
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
    
    static func getUser(infoType infoRequested: UserInfoType, forPlatform platform: Int, userId: String, completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        let infoRequest = UserMethods.infoRequest(platformType: platform, id: userId, infoType: infoRequested)
        WSAPI.shared.callService(url: infoRequest.fullPath, method: infoRequest.method, parameters: infoRequest.parameters, param_Encoding: infoRequest.encoding?.parameterEncoding, headers: infoRequest.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let responseData = responseInfo["Response"] as? EntityDictionary, let infoDictionary = responseData[infoRequested.keyword] as? EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(infoDictionary, nil)
            }
        }
        
    }
}
