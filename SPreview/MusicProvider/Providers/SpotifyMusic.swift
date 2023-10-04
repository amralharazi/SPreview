//
//  SpotifyMusic.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import Foundation

class SpotifyMusic: MusicProvider {
    
    // MARK: Properties
    private let requestManager: RequestManagerProtocol
    private let accessManager: TokenManagerProtocol
    private var nextLikedSongsRequestUrl: String?
    private var nextSearchedSongsRequestUrl: String?
    var searchTerm: String = ""
    var hasReachedTheEnd: Bool {
        isSearching ? nextSearchedSongsRequestUrl == nil : nextLikedSongsRequestUrl == nil
    }
    var isSearching = false
    
    // MARK: Init
    init(requestManager: RequestManagerProtocol = RequestManager(),
         accessManager: TokenManagerProtocol = TokenManager.shared) {
        self.requestManager = requestManager
        self.accessManager = accessManager
    }
    
    // MARK: Functions
    func getAuthorizationRequest() -> URLRequest? {
        if !accessManager.hasAccessToken() {
            return createAuthorizationRequest()
        }
        return nil
    }
    
    func getLikedSongs() async throws -> [SongItem] {
        let request = TracksRequest.getLikedTracks
        return try await getSongsWith(request: request)
    }
    
    func getSongsWith(searchTerm: String) async throws -> [SongItem] {
        let request = TracksRequest.getSongsWith(searchTerm: searchTerm)
        DispatchQueue.main.async {
            self.searchTerm = searchTerm
        }
        isSearching = true
        return try await getSongsWith(request: request)
    }
    
    func getNextSongBatch() async throws -> [SongItem] {
        guard !hasReachedTheEnd else {return []}
        guard let nextRequestUrl = searchTerm == "" ? nextLikedSongsRequestUrl : nextSearchedSongsRequestUrl else {return []}
        let request = TracksRequest.getBatchFrom(url: nextRequestUrl)
        return try await getSongsWith(request: request)
    }
}

// MARK: Helpers
extension SpotifyMusic {
    private func createAuthorizationRequest() -> URLRequest? {
        let scopeAsString = APIConstants.scopes.joined(separator: " ")
        var components = URLComponents()
        components.scheme = "https"
        components.host = APIConstants.authHost
        components.path = "/authorize"
        
        let params  = [
            "response_type": APIConstants.responseType,
            "client_id": SpotifyAuthKeys.clientId,
            "redirect_uri": APIConstants.redirectUri,
            "scope": scopeAsString]
        
        components.queryItems = params.map({URLQueryItem(name: $0, value: $1)})
        
        guard let url = components.url else {return nil}
        return try? URLRequest(url: url, method: .get)
    }
    
    private func getSongsWith(request: RequestProtocol) async throws -> [SongItem] {

        do {
            
            
            if !isSearching {
                let response: SpotifyTracks = try await requestManager.perform(request)
                self.nextLikedSongsRequestUrl = response.next
                let tracks = response.items?.compactMap({$0.track != nil ? $0 : nil}).map({$0.track!}) ?? []
                return convertToSongItems(tracks)
            } else {
                let response: SpotifySearchResult = try await requestManager.perform(request)
                self.nextSearchedSongsRequestUrl = response.tracks?.next
                let tracks = response.tracks?.items ?? []
                isSearching = false
                return convertToSongItems(tracks)
            }
            
            
            
        } catch {
            throw error
        }
    }
    
    private func convertToSongItems(_ tracks: [SpotifyTrack]) -> [SongItem] {
        return tracks.map { track in
            return createSongItem(from: track)
        }
    }
    
    private func createSongItem(from track: SpotifyTrack?) -> SongItem {
        let songName = track?.name ?? ""
        let artistName = track?.album?.artists.first?.name
        let image = getSmallestImageUrl(from: track?.album?.images)
        let previewUrl = track?.preview_url
        return SongItem(songName: songName,
                        artistName: artistName,
                        image: image,
                        previewUrl: previewUrl)
    }
    
    private func getSmallestImageUrl(from images: [SpotifyImage]?) -> String {
        let nonNilImages = images?.compactMap { $0.height != nil ? $0 : nil } ?? []
        return nonNilImages.sorted { $0.height! < $1.height! }.first?.url ?? ""
    }
}
