//
//  CurrentSession.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 03/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

class CurrentSession {
    
    static let shared = CurrentSession()
    
    public private(set) var token: Token? = nil
    public private(set) var user: User? = nil
    
    func update(token: Token?) {
        self.token = token
    }
    
    func update(user: User?) {
        self.user = user
    }
    
    func cleanSession() {
        self.user = nil
        self.token = nil
    }
    
}
