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
    var delegate: MusicProviderDelegate?
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
    func requestAuthorization() async {
        if !accessManager.hasAccessToken() {
            guard let request = TokenRequest.getAccessTokenRequest() else {return}
            delegate?.presentWebView(with: request)
        }
    }
    
    func getSavedSongs() async -> [SongItem] {
        let request = SavedTracksRequest.getSavedTracks
        do {
            let response: SpotifyPlaylistTracks = try await requestManager.perform(request)
            self.nextRequestUrl = response.next
            return convertToSongItems(response)
        } catch {
            delegate?.showPopup(with: error.localizedDescription)
            return []
        }
    }
    
    func getNextSongBatch() async -> [SongItem] {
        guard let nextRequestUrl = nextRequestUrl else {return []}
        let request = SavedTracksRequest.getBatchFrom(url: nextRequestUrl)
        do {
            let response: SpotifyPlaylistTracks = try await requestManager.perform(request)
            self.nextRequestUrl = response.next
            return convertToSongItems(response)
        } catch {
            delegate?.showPopup(with: error.localizedDescription)
            return []
        }
    }
}

// MARK: Helpers
extension SpotifyMusic {
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
