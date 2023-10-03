//
//  Connectivity.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire

class Connectivity {
        
    static var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    
    static func checkInternetConnection() throws {
        if !Connectivity.isConnectedToInternet {
            throw NetworkError.noConnection
        }
    }
}
