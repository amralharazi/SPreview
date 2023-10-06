//
//  RequestManager.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

protocol RequestManagerProtocol {
    var accessTokenManager: TokenManagerProtocol { get }
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

class RequestManager: RequestManagerProtocol {
    
    // MARK: Properties
    let apiManager: APIManagerProtocol
    let parser: DataParserProtocol
    let accessTokenManager: TokenManagerProtocol
    
    // MARK: Init
    init(apiManager: APIManagerProtocol = APIManager(),
         parser: DataParserProtocol = DataParser(),
         accessTokenManager: TokenManagerProtocol = TokenManager.shared) {
        self.apiManager = apiManager
        self.parser = parser
        self.accessTokenManager = accessTokenManager
    }
    
    // MARK: Helpers
    func perform<T: Decodable>(_ request: RequestProtocol)
    async throws -> T {
        
        let authToken = try await requestAccessToken()
        let data = try await apiManager.perform(request,
                                                authToken: authToken)
        
        let decoded: T = try parser.parse(data: data)
        return decoded
    }
    
    func requestAccessToken() async throws -> String {
        if accessTokenManager.isTokenValid() {
            return accessTokenManager.fetchAccessToken()
        }
        let data = try await apiManager.requestToken()
        let token: AccessTokens = try parser.parse(data: data)
        try accessTokenManager.refreshWith(token: token)
        return token.access_token ?? ""
        
    }
}
