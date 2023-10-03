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
        let request = SavedTracksRequest.getSavedTracks
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
        let request = SavedTracksRequest.getBatchFrom(url: nextRequestUrl)
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
        self.nextRequestUrl = response.next
        guard let items = response.items else {return []}
        return items.map({SongItem(songName: $0.track?.name ?? "",
                                   artistName: $0.track?.album?.artists.first?.name,
                                   image: getSmallestimage(from: $0.track?.album?.images),
                                   previewUrl: $0.track?.preview_url)})
    }
    
    private func getSmallestimage(from images: [SpotifyImage]?) -> String {
        if let images = images,
           images.count > 1 {
            let nonNilImages = images.compactMap({$0.height != nil ? $0 : nil})
            return nonNilImages.sorted(by: {$0.height! < $1.height!}).first?.url ?? ""
        } else {
            return images?.first?.url ?? ""
        }
    }
}
