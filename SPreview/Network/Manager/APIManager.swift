//
//  APIManager.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation
import Alamofire

protocol APIManagerProtocol {
    func perform(_ request: RequestProtocol,
                 authToken: String) async throws -> Data
    func requestToken() async throws -> Data
}

class APIManager: APIManagerProtocol {
    
    // MARK: Properties
    private let accessTokenManager = TokenManager.shared
    
    // MARK: Helpers
    func perform(_ request: RequestProtocol,
                 authToken: String = "") async throws -> Data {
        
        try Connectivity.checkInternetConnection()
        
        var _headers = request.headers
        
        if request.needsAuthKey {
            _headers["Authorization"] = "Bearer \(authToken)"
        }
        
        if let url = URL(string: "\(request.host)\(request.path)") {
            return try await withUnsafeThrowingContinuation({ continuation in
                AF.request(url,
                           method: request.requestType,
                           parameters: request.params,
                           encoding: request.encoding,
                           headers: _headers).responseData { response in
//                    debugPrint(response)
                    
                    switch response.result {
                        
                    case .success(let data):
//                        print(String(data: data, encoding: .utf8) as Any)
                        continuation.resume(returning: data)
                        return
                    case .failure(let error):
                        print(error)
                        continuation.resume(throwing: error)
                        return
                    }
                }
            })
        } else {
            throw URLError(.badURL)
        }
    }
    
    func requestToken() async throws -> Data {
        try await perform(TokenRequest.getRefreshedToken)
    }
}
