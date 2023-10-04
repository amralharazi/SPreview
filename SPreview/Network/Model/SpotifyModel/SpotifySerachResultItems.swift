//
//  SpotifySerachResultItems.swift
//  SPreview
//
//  Created by Amr on 4.10.2023.
//

import Foundation

struct SpotifySerachResultItems: Codable {
    let next: String?
    let items: [SpotifyTrack]?
}
