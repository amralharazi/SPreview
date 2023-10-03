//
//  SpotifyTrack.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct SpotifyTrack: Codable {
    let album: SpotifyAlbum?
    let name: String
    let preview_url: String?
}
