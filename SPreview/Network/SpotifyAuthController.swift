//
//  SpotifyAuthController.swift
//  SPreview
//
//  Created by Amr on 21.10.2024.
//


import SpotifyiOS

class SpotifyAuthController: NSObject, ObservableObject {
    
    // MARK: Properties
    static let shared = SpotifyAuthController()
    let encryptedClientIdBytes: [UInt8] = SpotifyKeys.clientID // the aes encrypted client id byte array with PBKDF2 key
    let encryptedSecretKeyBytes: [UInt8] = SpotifyKeys.secretKey // the aes encrypted secret key byte array with PBKDF2 key
    
    var clientId = ""
    var secretKey = ""
    var responseCode: String?
    
    let scopes: SPTScope = [
        .userReadPrivate,
        .playlistReadPrivate,
        .userLibraryRead,
        .userFollowRead,
        .userModifyPlaybackState,
        .userReadPlaybackState
    ]
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: clientId, redirectURL: URL(string:"SPreview://")!)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating
        // otherwise another app switch will be required
        configuration.playURI = ""
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "http://localhost:1234/swap")
        configuration.tokenRefreshURL = URL(string: "http://localhost:1234/refresh")
        return configuration
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.connectionParameters.accessToken = TokenManager.shared.fetchAccessToken()
        return appRemote
    }()
    
    lazy var sessionManager: SPTSessionManager? = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    // MARK: Init
    private override init(){
        super.init()
    }
    
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
    
    func authenticateSpotify() {
        guard let sessionManager = sessionManager else { return }
        sessionManager.initiateSession(with: scopes, options: .clientOnly, campaign: "")
    }
    
    func fetchAccessToken(code: String) async throws {
        let request = SpotifyTokenRequest.getAuthKeys(code: code)
        let response: AccessTokens = try await RequestManager().requestAuthKeys(request)
        try TokenManager.shared.refreshWith(token: response)
    }
}

// MARK: - SPTSessionManagerDelegate
extension SpotifyAuthController: SPTSessionManagerDelegate {
    func sessionManager(
        manager: SPTSessionManager,
        didFailWith error: Error) {
            if error.localizedDescription == "The operation couldn’t be completed. (com.spotify.sdk.login error 1.)" {
                print("AUTHENTICATE with WEBAPI")
            } else {
                print("Authorization Failed: \(error)")
            }
        }
    
    func sessionManager(
        manager: SPTSessionManager,
        didRenew session: SPTSession) {
            print("Session Renewed")
        }
    
    func sessionManager(
        manager: SPTSessionManager,
        didInitiate session: SPTSession) {
            
        }
}

