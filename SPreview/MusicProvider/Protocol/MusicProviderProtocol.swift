//
//  MusicProviderProtocol.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import Foundation

protocol MusicProvider {
    var delegate: MusicProviderDelegate? { get set }
    var hasReachedTheEnd: Bool { get }
    func requestAuthorization() async
    func getSavedSongs() async -> [SongItem]
    func getNextSongBatch() async -> [SongItem]
}

protocol MusicProviderDelegate {
    func presentWebView(with request: URLRequest)
    func showPopup(with message: String)
}
