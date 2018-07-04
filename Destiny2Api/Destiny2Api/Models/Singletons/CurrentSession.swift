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
    
    func update(token: Token?) {
        self.token = token
    }
    
    func cleanSession() {
        self.token = nil
    }
    
}
