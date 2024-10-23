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
    static let localRedirectURI = "SPreview://"
    static let responseType = "code"
    static let scopes = [
        "user-read-private",
        "playlist-read-private",
        "user-library-read"
    ]
}
