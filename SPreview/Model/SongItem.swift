//
//  SongItem.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import Foundation

struct SongItem {
    let songName: String
    var artistName: String?
    var image: String?
    var previewUrl: String?
}

extension SongItem {
    static let dummySong = SongItem(songName: "Indigo Night",
                                    artistName: "Tamino",
                                    image: "tamino")
}
