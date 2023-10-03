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
    
    // MARK: Content
    var body: some Scene {
        WindowGroup {
            if !accessManager.hasAccessToken() {
                AuthorizationView(musicProvider: musicProvider)
            } else {
                SavedSongsView(musicProvider: musicProvider)
                    .withErrorHandling()
            }
        }
    }
}
