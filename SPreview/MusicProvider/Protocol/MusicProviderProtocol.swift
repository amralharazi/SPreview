//
//  MusicProviderProtocol.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import Foundation

protocol MusicProvider {
    var hasReachedTheEnd: Bool { get }
    var searchTerm: String {get set}
    
    func getAuthorizationRequest() -> URLRequest?
    func getLikedSongs() async throws -> [SongItem]
    func getSongsWith(searchTerm: String) async throws -> [SongItem]
    func getNextSongBatch() async throws -> [SongItem]
}
