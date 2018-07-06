//
//  LoginEndpoints.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 03/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

enum LoginServices: EndpointConfiguration {
    
    case token(code: String)
    case refreshToken(refreshToken: String)
    
    var serverURL: String {
        return Endpoint().serverURL
    }
    
    var path: String {
        return "/app/oauth/token/"
    }
    
    var fullPath: String {
        return "\(serverURL)\(path)"
    }
    
    var method: webMethod {
        return .POST
    }
    
    var parameters: BasicDictionary? {
        switch self {
        case .token(let code): return ["grant_type": "authorization_code", "code": code, "client_id": client_Id, "client_secret": clientSecret]
        case .refreshToken(let refreshToken): return ["grant_type": "refresh_token", "refresh_token": refreshToken, "client_id": client_Id, "client_secret": clientSecret]
        }
    }
    
    var encoding: encoding? {
        return .urlBody
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
}

struct LoginEndpoints {
    
    static func getToken(code: String, completion: @escaping ((_ token: Token?,_ error: NSError?) -> Void)) {
        
        let getToken = LoginServices.token(code: code)
    
        WSAPI.shared.callService(url: getToken.fullPath, method: getToken.method, parameters: getToken.parameters, param_Encoding: getToken.encoding?.parameterEncoding, headers: getToken.headers) { response, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else {
                do {
                    let tokenDecoded = try JSONDecoder().decode(Token.self, from: response!)
                    completion(tokenDecoded, nil)
                } catch {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                }
            }
        }
    }
    
    static func refreshToken(_ refreshToken: String, completion: @escaping ((_ token: Token?,_ error: NSError?) -> Void)) {
        
        let refreshToken = LoginServices.refreshToken(refreshToken: refreshToken)
        WSAPI.shared.callService(url: refreshToken.fullPath, method: refreshToken.method, parameters: refreshToken.parameters, param_Encoding: refreshToken.encoding?.parameterEncoding, headers: refreshToken.headers) { response, error in
            if let errorWeb = error {
                completion(nil, errorWeb)
            } else {
                do {
                    let tokenDecoded = try JSONDecoder().decode(Token.self, from: response!)
                    completion(tokenDecoded, nil)
                } catch {
                    completion(nil, NSError(domain: "LibraryApi", code: -3, userInfo: nil))
                }
            }
        }
    }
    
}
