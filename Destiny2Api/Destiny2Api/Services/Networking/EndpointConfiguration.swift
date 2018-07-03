//
//  WSEndpointsProtocol.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation

protocol EndpointConfiguration {
    var serverURL: String { get }
    var path: String { get }
    var fullPath: String { get }
    var method: webMethod { get }
    var parameters: BasicDictionary? { get }
    var encoding: encoding? { get }
    var headers: [String: String]? { get }
}

struct Endpoint {
    
    var serverURL: String {
        return "https://www.bungie.net/Platform/Destiny2"
    }
    
    var bungieImages: String {
        return "https://www.bungie.net"
    }
}
