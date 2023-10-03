//
//  SpotifyAlbum.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct SpotifyAlbum: Codable {
    let artists: [SpotifyArtist]
    let images: [SpotifyImage]?
}
