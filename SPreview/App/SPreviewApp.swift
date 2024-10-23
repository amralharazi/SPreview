//
//  SPreviewApp.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

@main
struct SPreviewApp: App {
    
    // MARK: Properties
    private let accessManager = TokenManager.shared
    private var musicProvider = SpotifyMusic()
    @StateObject var spotifyAuthController = SpotifyAuthController.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var isAuthenticated = false
       
    
    // MARK: Content
    var body: some Scene {
        WindowGroup {
            if !isAuthenticated && !accessManager.hasAccessToken() {
                AuthorizationView(musicProvider: musicProvider)
                    .onOpenURL { url in
                        handleOpenURL(url)
                    }
            } else {
                SavedSongsView<SpotifyMusic>()
                    .withErrorHandling()
                    .environmentObject(musicProvider)
            }
        }
    }
    
    func handleOpenURL(_ url: URL) {
        Task {
            let parameters = spotifyAuthController.appRemote.authorizationParameters(from: url)
            if let code = parameters?["code"] {
                spotifyAuthController.responseCode = code
                try await spotifyAuthController.fetchAccessToken(code: code)
                isAuthenticated = true
            }
        }
    }
}
