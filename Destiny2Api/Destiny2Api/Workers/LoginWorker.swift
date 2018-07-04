//
//  LoginWorker.swift
//  kn·Connect
//
//  Created by Jorge Armando Rebollo Jiménez on 26/12/17.
//  Copyright (c) 2017 Knotion. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import Foundation

let lastUserLogged = "lastUserLogged"
let loggedInOffline = "loggedInOffline"

class LoginWorker {
    // MARK: Worker Singleton
    private init() { }
    static let shared = LoginWorker()
    
    // MARK: Session Scene Works
    
    func validateCurrentToken(onCompletion: @escaping((_ error: NSError?) -> Void)) {
        let realmApi = RealmApi()
        
        guard let thisToken = realmApi.realm.objects(Token_Persistance.self).first, let token = try? Token(dictionary: thisToken.dictionary) else {
            onCompletion(NSError(domain: "LoginWorker", code: -1, userInfo: ["error": "Token value is compromissed"]))
            return
        }
        
        CurrentSession.shared.update(token: token)
        
        if Date() >= thisToken.expires_in! {
            
            LoginEndpoints.refreshToken(thisToken.refresh_token) { response, error in
                if let newToken = response {
                    CurrentSession.shared.update(token: newToken)
                    
                    if let tokenPersistance = Token_Persistance(dictionary: newToken.dictionary) {
                        let realmAPI = RealmApi()
                        realmAPI.write(tokenPersistance)
                    }
                    
                    onCompletion(nil)
                    
                } else {
                    onCompletion(error)
                }
            }
        } else {
            onCompletion(nil)
        }
    }
    
    func doLogin(with code:String, onCompletion: @escaping((_ error: NSError?) -> Void)) {
        
        LoginEndpoints.getToken(code: code) { response, error in
            
            if let newToken = response {
                CurrentSession.shared.update(token: newToken)
                
                if let tokenPersistance = Token_Persistance(dictionary: newToken.dictionary) {
                    let realmAPI = RealmApi()
                    realmAPI.write(tokenPersistance)
                }
                
                onCompletion(nil)
                
            } else {
                onCompletion(error)
            }
        }
    }
    
}
