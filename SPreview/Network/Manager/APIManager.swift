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
                 authToken: String?) async throws -> Data
    func requestRefreshToken() async throws -> Data
}

class APIManager: APIManagerProtocol {
    
    // MARK: Properties
    private let accessTokenManager = TokenManager.shared
    
    // MARK: Helpers
    func perform(_ request: RequestProtocol,
                 authToken: String? = nil) async throws -> Data {
        
        try Connectivity.checkInternetConnection()
        let headers = configureHeaders(for: request, with: authToken)
        let url = try getUrl(from: request)
        
        return try await withCheckedThrowingContinuation({ continuation in
            AF.request(url,
                       method: request.requestType,
                       parameters: request.params,
                       encoding: request.encoding,
                       headers: headers).responseData { response in
//                debugPrint(response)
                
                if authToken != "" && (response.response?.statusCode == 400 ||
                                       response.response?.statusCode == 401) {
                    let error = SpotifyError.notAuthorized
                    continuation.resume(throwing: error)
                    return
                }
                
                switch response.result {
                    
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
    
    func requestRefreshToken() async throws -> Data {
        try await perform(TokenRequest.getRefreshedToken)
    }
}

private extension APIManager {
    func configureHeaders(for request: RequestProtocol,
                          with token: String?) -> HTTPHeaders {
        var headers = request.headers
        if let token = token,
           request.needsAuthKey {
            headers["Authorization"] = "Bearer \(token)"
        }
        
        return headers
    }
    
    func getUrl(from request: RequestProtocol) throws -> URL {
        guard let url = URL(string: "\(request.host)\(request.path)") else {
            throw URLError(.badURL)
        }
        return url
    }
}
