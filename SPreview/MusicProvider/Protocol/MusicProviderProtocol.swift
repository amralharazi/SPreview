//
//  MusicProviderProtocol.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import Foundation

protocol MusicProvider: ObservableObject {
    var hasReachedTheEnd: Bool { get }
    var searchTerm: String {get set}
    
    func getAuthToken(from url: String, completion: @escaping (Bool) -> Void)
    func getAuthorizationRequest() -> URLRequest?
    func getLikedSongs() async throws -> [SongItem]
    func getSongsWith(searchTerm: String) async throws -> [SongItem]
    func cancelSearching()
    func getNextSongBatch() async throws -> [SongItem]
}
