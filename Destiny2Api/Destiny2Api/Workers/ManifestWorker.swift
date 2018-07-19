//
//  ManifestWorker.swift
//  Destiny2Api
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 18/07/18.
//  Copyright © 2018 Aldo Rogelio Bonilla  Guerrero. All rights reserved.
//

import Foundation

struct ManifestWorker {
    
    static func getManifestDisplayProperties(type: EntityTypeManifest, hash: Int,_ completion:@escaping ((_ displayProperties: DisplayManifest?,_ error: NSError?) -> Void)) {
        ManifestEndpoints.getManifestFor(type, hash: String(hash)) { response, error  in
            if let entityDict = response, let displayDict = entityDict["displayProperties"] as? EntityDictionary {
                do {
                    let manifest = try DisplayManifest(dictionary: displayDict)
                    completion(manifest, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
        }
    }
    
    static func getManifestFor<T: EntityProtocol>(type: EntityTypeManifest, hash: Int,_ completion:@escaping ((_ manifest: T?,_ error: NSError?) -> Void)) {
        ManifestEndpoints.getManifestFor(type, hash: String(hash)) { response, error  in
            if let entityDict = response {
                do {
                    let manifest = try T(dictionary: entityDict)
                    completion(manifest, nil)
                } catch {
                    completion(nil, NSError(domain: "Worker", code: 100, userInfo: ["description": "User data is corrupted"]))
                }
            } else {
                completion(nil, error)
            }
        }
    }
}
