//
//  APIConstants.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct APIConstants {
    static let host = "https://api.spotify.com"
    static let authHost = "accounts.spotify.com"
    static let redirectUri = "https://www.google.com"
    static let responseType = "code"
    static let scopes = [
        "user-read-email", "user-read-private",
        "user-read-playback-state", "user-modify-playback-state", "user-read-currently-playing",
        "streaming", "app-remote-control",
        "playlist-read-collaborative", "playlist-modify-public", "playlist-read-private", "playlist-modify-private",
        "user-library-modify", "user-library-read",
        "user-top-read", "user-read-playback-position", "user-read-recently-played",
        "user-follow-read", "user-follow-modify",
    ]
}
