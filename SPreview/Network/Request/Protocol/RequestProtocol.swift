//
//  RequestProtocol.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Alamofire
import Foundation

protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var headers: HTTPHeaders { get }
    var params: [String: Any] { get }
    var encoding: ParameterEncoding { get }
    var needsAuthKey: Bool { get }
    var requestType: HTTPMethod { get }
}

extension RequestProtocol {
    var host: String {
        APIConstants.host
    }
    
    var needsAuthKey: Bool {
        true
    }
    
    var params: [String: Any] {
        [:]
    }
    
    var headers: HTTPHeaders {
        ["Content-Type": "application/json",
         "Accept": "application/json"]
    }
}
