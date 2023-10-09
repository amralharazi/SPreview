//
//  SpotifyAuthKeys.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

class SpotifyAuthController {
    
    // MARK: Properties
    static let shared = SpotifyAuthController()
    let encryptedClientIdBytes: [UInt8] = [] // the aes encrypted client id byte array with PBKDF2 key
    let encryptedSecretKeyBytes: [UInt8] = [] // the aes encrypted secret key byte array with PBKDF2 key
    
    var clientId = ""
    var secretKey = ""
    
    // MARK: Init
    private init(){}
    
    // MARK: Helpers
    func setup() {
        do {
            try decryptKeys()
        } catch {
            print(error)
        }
    }
    
    private func decryptKeys() throws {
        let key = try PBKDF2Generator.generateKey(password: Bundle.main.bundleIdentifier ?? "")
        guard let aes = AES(key: key, iv: Data(key.reversed())) else {return}
        
        
        if let decryptedClientId = aes.decrypt(data: Data(encryptedClientIdBytes)) {
            clientId = String(data: decryptedClientId, encoding: .utf8) ?? ""
        }
                
        if let decryptedSecretKey = aes.decrypt(data: Data(encryptedSecretKeyBytes)) {
            secretKey = String(data: decryptedSecretKey, encoding: .utf8) ?? ""
        }
    }
}
