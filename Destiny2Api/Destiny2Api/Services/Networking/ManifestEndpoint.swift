//
//  ManifestEndpoint.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 05/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum ManifestMethods: EndpointConfiguration {
    
    case getManifestFor(entityType: EntityTypeManifest, hashId: String)
    
    var serverURL: String {
        return Endpoint().serverURL
    }
    
    var path: String {
        switch self {
        case .getManifestFor(let entityType, let hashId): return "/Destiny2/Manifest/\(entityType.rawValue)\(hashId)"
        }
    }
    
    var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    var method: webMethod {
        return .GET
    }
    
    var parameters: BasicDictionary? {
        return nil
    }
    
    var encoding: encoding? {
        return .url
    }
    
    var headers: [String : String]? {
        return [headerApiDestiny: destinyApiKey]
    }
    
}

struct ManifestEndpoints {
    
    static func getManifestFor(_ entityType: EntityTypeManifest, hash: String, completion: @escaping ((_ userInfo: EntityDictionary?,_ error: NSError?) -> Void )) {
        
        let getInfo = ManifestMethods.getManifestFor(entityType: entityType, hashId: hash)
        
        WSAPI.shared.callService(url: getInfo.fullPath, method: getInfo.method, parameters: getInfo.parameters, param_Encoding: getInfo.encoding?.parameterEncoding, headers: getInfo.headers) { response, error in
            if error != nil {
                completion(nil, error)
            } else {
                guard let responseInfo = try? JSONSerialization.jsonObject(with: response!, options: []) as! EntityDictionary, let responseData = responseInfo["Response"] as? EntityDictionary else {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                    return
                }
                completion(responseData, nil)
            }
        }
    }
}
