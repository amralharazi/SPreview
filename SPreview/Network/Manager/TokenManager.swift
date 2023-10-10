//
//  TokenManager.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

protocol TokenManagerProtocol {
    func isTokenValid() -> Bool
    func hasAccessToken() -> Bool
    func refreshWith(token: AccessTokens) throws
    func fetchAccessToken() -> String
    func fetchRefreshToken() -> String
}

class TokenManager: TokenManagerProtocol {
    
    // MARK: Properties
    private let userDefaults = UserDefaults.standard
    private var accessToken: String? = nil
    private var refreshToken: String? = nil
    private var expires_in = Date()
    private var keysPersistence = AuthController.shared
    static let shared = TokenManager()
        
    enum TokenStoreKeys: String {
        case accessToken
        case refreshToken
        case expirationDateInSeconds
    }
    
    // MARK: Init
    private init() {
        update()
    }
    
    // MARK: Helpers
    func isTokenValid() -> Bool {
        return expires_in.compare(Date()) == .orderedDescending
    }
    
    func hasAccessToken() -> Bool {
        return accessToken != nil
    }
    
    func refreshWith(token: AccessTokens) throws {
        self.accessToken = token.access_token
        self.refreshToken = token.refresh_token
        if let allowedSeconds = token.expires_in {
            self.expires_in = Date(timeIntervalSince1970: Date().timeIntervalSince1970 + Double(allowedSeconds))
        }
        save(token: token)
    }
    
    func fetchAccessToken() -> String {
        guard let accessToken = accessToken else {
            return ""
        }
        return accessToken
    }
    
    func fetchRefreshToken() -> String {
        guard let refreshToken = refreshToken else {
            return ""
        }
        return refreshToken
    }
    
    private func save(token: AccessTokens) {
        if let access_token = token.access_token {
            try? keysPersistence.setValue(access_token, for: TokenStoreKeys.accessToken.rawValue)
        }
        
        if let refresh_token = token.refresh_token {
            try? keysPersistence.setValue(refresh_token, for: TokenStoreKeys.refreshToken.rawValue)
        }
        
        if let expires_in = token.expires_in {
            userDefaults.set(Date().timeIntervalSince1970+Double(expires_in), forKey: TokenStoreKeys.expirationDateInSeconds.rawValue)
        }
    }
    
    private func getExpirationDate() -> Date {
        guard let seconds = userDefaults.value(forKey: TokenStoreKeys.expirationDateInSeconds.rawValue) as? Double else {
            return Date()
        }
        return Date(timeIntervalSince1970: seconds)
    }
    
    private func getAccessToken() -> String? {
        try? keysPersistence.getValue(for: TokenStoreKeys.accessToken.rawValue)
    }
    
    private func getRefreshToken() -> String? {
        try? keysPersistence.getValue(for: TokenStoreKeys.refreshToken.rawValue)
    }
    
    private func update() {
        accessToken = getAccessToken()
        refreshToken = getRefreshToken()
        expires_in = getExpirationDate()
    }
}
