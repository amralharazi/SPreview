//
//  MusicProviderProtocol.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import Foundation

protocol MusicProvider {
    var hasReachedTheEnd: Bool { get }
    
    func getAuthorizationRequest() -> URLRequest?
    func getSavedSongs() async throws -> [SongItem]
    func getNextSongBatch() async throws -> [SongItem]
}
