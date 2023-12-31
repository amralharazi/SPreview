//
//  SongItem.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct SongItem: Identifiable, Equatable {
    let id = UUID()
    let songName: String
    var artistName: String?
    var image: String?
    var previewUrl: String?
    var spotifyUri: String?
}

extension SongItem {
    static let dummySong = SongItem(songName: "Indigo Night",
                                    artistName: "Tamino",
                                    image: "tamino")
}
