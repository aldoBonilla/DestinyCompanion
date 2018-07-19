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
    case infoRequest(platformType: Int, id: String, infoType: UserInfoType, itemRequested: String)
    case currentUserInfo
    
    var serverURL: String {
        return Endpoint().serverURL
    }
    
    var path: String {
        switch self {
        case .searchPlayer(let platform, let username): return "/SearchDestinyPlayer/\(platform)/\(username)"
        case .infoRequest(let platform, let userid, let infoType, let itemRequested): return "/Destiny2/\(platform)/Profile/\(userid)/\(infoType.additionalPath)\(itemRequested)"
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
        case .infoRequest( _, _, let requestType, _): return ["components": "\(requestType.componentValue)"]
        }
    }
    
    var encoding: encoding? {
        return .url
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchPlayer: return [headerApiDestiny: destinyApiKey]
        case .currentUserInfo: return [headerApiDestiny: destinyApiKey, "Authorization": "Bearer \(CurrentSession.shared.token!.access_token)"]
        case .infoRequest(_, _, let requestType, _):
            if requestType.privacyLvl == 2 {
                return ["Authorization": "Bearer \(CurrentSession.shared.token!.access_token)", headerApiDestiny: destinyApiKey]
            }
            else {return [headerApiDestiny: destinyApiKey] }
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
    
    static func requestInfo(infoType infoRequested: UserInfoType, itemRequested: String = "", forPlatform platform: Int, userId: String, completion: @escaping ((_ userInfo: EntityDictionary?, _ error: NSError?) -> Void )) {
        let infoRequest = UserMethods.infoRequest(platformType: platform, id: userId, infoType: infoRequested, itemRequested: itemRequested)
        WSAPI.shared.callService(url: infoRequest.fullPath, method: infoRequest.method, parameters: infoRequest.parameters, param_Encoding: infoRequest.encoding?.parameterEncoding, headers: infoRequest.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary,
                      let responseData = responseInfo["Response"] as? EntityDictionary,
                      let requestedDict = responseData[infoRequested.keyword] as? EntityDictionary,
                      let requestedData = requestedDict["data"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(requestedData, nil)
            }
        }
    }
    
    static func getCharacterInventories(_ id: String, _ completion: @escaping((_ itemsDictionary: EntityDictionary?, _ error: NSError?) -> Void )) {
        let headers = [
            headerApiDestiny: destinyApiKey,
            "Authorization": "Bearer \(CurrentSession.shared.token!.access_token)"
        ]
        
        let request = NSMutableURLRequest(url:( URL(string: "\(Endpoint().serverURL)/Destiny2/\(CurrentSession.shared.userPlatform)/Profile/\(CurrentSession.shared.userMembership)/character/\(id)/?components=201"))!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print (error)
                completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
            } else if data != nil {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: data!, options: []) as! EntityDictionary,
                    let responseData = responseInfo["Response"] as? EntityDictionary,
                    let requestedDict = responseData["inventory"] as? EntityDictionary,
                    let requestedData = requestedDict["data"] as? EntityDictionary else {
                        completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                        return
                }
            }
        }
        dataTask.resume()
    }
}
