//
//  WSAPI.swift
//  kn·Connect
//
//  Created by Aldo Rogelio Bonilla  Guerrero on 10/11/17.
//  Copyright © 2017 Knotion. All rights reserved.
//

import Foundation
import Alamofire

///Diccionario comun para los init de modelos
typealias BasicDictionary = Dictionary<String, Any>

///Diccionario comun para los init de modelos
typealias EntityDictionary = Dictionary<String, Any?>

let headerApiDestiny = "X-API-Key"
let destinyApiKey = "aa8ac79909674f1da752313d781f582e"

enum webMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}

enum encoding {
    
    case url
    case json
    case multipart
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .url: return URLEncoding.default
        case .json: return JSONEncoding.default
        case .multipart: return MultipartEncoding()
        }
    }
}

struct MultipartEncoding: ParameterEncoding {
    
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return urlRequest }
        
        let multipart = MultipartFormData()
    
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("multipart/form-data; boundary=\(multipart.boundary)", forHTTPHeaderField: "Content-Type")
        }
        
        parameters.forEach({ key, value in
            if let thisParam = value as? String {
                multipart.append(thisParam.data(using: .utf8)!, withName: key)
            }
        })
        
        urlRequest.httpBody = try! multipart.encode()
        
        return urlRequest
    }
}

class WSAPI {
    
    public static let topicNetWorkEnable = NSNotification.Name("NetWorkEnable")
    public static let topicNetWorkDisallow = NSNotification.Name("NetWorkNotEnable")
    
    static let shared = WSAPI()
    
    //Variable para indicar si es por primera vez que se carga la clase para monitorear la red
    static var isFirstCheck = true
    
    var manager: NetworkReachabilityManager?
    
    func callService(url: String, method: webMethod, parameters: BasicDictionary?, param_Encoding: ParameterEncoding?, headers: [String: String]? = nil, onCompletion: @escaping((_ response: Data?, _ error: NSError?) -> Void )) {
        setupReachability()
        if manager?.networkReachabilityStatus == .notReachable {
            onCompletion(nil, NSError(domain: "WSApi", code: -2, userInfo: nil))
            return
        }
        
        Alamofire.request(url, method: Alamofire.HTTPMethod(rawValue: method.rawValue)!, parameters: parameters, encoding: param_Encoding ?? URLEncoding.default, headers: headers)
            .validate()
            .responseJSON(queue: DispatchQueue.global(), options: .allowFragments, completionHandler: { alamoResponse in
                guard alamoResponse.result.isSuccess else {
                    
                    print("response failed for service: \(url)")
                    onCompletion(nil, NSError(domain: "WSApi", code: alamoResponse.response?.statusCode ?? -1, userInfo: nil))
                    return
                }
                guard let json = alamoResponse.data else {
                    onCompletion(nil, NSError(domain: "WSApi", code: -2, userInfo: nil))
                    return
                }
                onCompletion(json, nil)
            })
    }
    
    func downloadFile(urlFile: String, toLocation location: URL, completion: @escaping((_ fileSaved: URL?, _ error: NSError?) -> Void )) {
        setupReachability()
        if manager?.networkReachabilityStatus == .notReachable {
            completion(nil, NSError(domain: "WSApi", code: -2, userInfo: nil))
            return
        }
        let destination: DownloadRequest.DownloadFileDestination = {_, _ in
            return (location, [.removePreviousFile, .createIntermediateDirectories])
        }
        Alamofire.download(urlFile, to: destination).response { response in
            if response.error != nil {
                print("response failed for service: \(urlFile)")
                completion(nil, NSError(domain: "WSApi", code: response.response?.statusCode ?? -1, userInfo: ["descroption": "couldn't download file"]))
                return
            }
            
            guard let destinationUrl = response.destinationURL else {
                print("response failed for service: \(urlFile)")
                completion(nil, NSError(domain: "WSApi", code: response.response?.statusCode ?? -1, userInfo: ["descroption": "couldn't save file"]))
                return
            }
            
            completion(destinationUrl, nil)
        }
    }
    
    func setupReachability() {
        
        if manager != nil {
            WSAPI.isFirstCheck = false
            return
        }

        manager = NetworkReachabilityManager(host: "www.apple.com")
        manager?.listener = { status in
            print("Network Status Changed: \(status)")

            if WSAPI.isFirstCheck {
                return
            }
            
            if status == .notReachable {
                
                NotificationCenter.default.post(name: WSAPI.topicNetWorkDisallow, object: nil)
                return
            }
            
            NotificationCenter.default.post(name: WSAPI.topicNetWorkEnable, object: nil)
        }
        manager?.startListening()
    }
    
}


extension Notification.Name {
    static let unauthorizedRequest = Notification.Name("unauthorizedRequest")
}
