//
//  SpotifyTracks.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct SpotifyTracks: Codable {
    let items: [SpotifyTrackDetail]?
    let next: String?
}
