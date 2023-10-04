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
    private var nextRequestUrl: String?
    var hasReachedTheEnd: Bool {
        nextRequestUrl == nil
    }
    
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
    
    func getSavedSongs() async throws -> [SongItem] {
        let request = LikedTracksRequest.getLikedTracks
        do {
            let response: SpotifyPlaylistTracks = try await requestManager.perform(request)
            self.nextRequestUrl = response.next
            return convertToSongItems(response)
        } catch {
            throw error
        }
    }
    
    func getNextSongBatch() async throws -> [SongItem] {
        guard let nextRequestUrl = nextRequestUrl else {return []}
        let request = LikedTracksRequest.getBatchFrom(url: nextRequestUrl)
        do {
            let response: SpotifyPlaylistTracks = try await requestManager.perform(request)
            self.nextRequestUrl = response.next
            return convertToSongItems(response)
        } catch {
            throw error
        }
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
    
    private func convertToSongItems(_ response: SpotifyPlaylistTracks) -> [SongItem] {
        let items = response.items ?? []
        return items.map { item in
             let track = item.track
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
