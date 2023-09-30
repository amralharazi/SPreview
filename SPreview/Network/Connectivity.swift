//
//  Connectivity.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire

class Connectivity {
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}
