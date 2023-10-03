//
//  MusicPlayer.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import AVFoundation
import Foundation

class MusicPlayer: NSObject,
                   ObservableObject {
    
    // MARK: Properties
    static let shared = MusicPlayer()
    private var player = AVPlayer()
    private var progressObserver: Any?
    
    @Published var hasFinished: Bool?
    @Published var progress: Double = 0
    
    
    // MARK: Init
    private override init() {
        super.init()
        configurePlayer()
    }
    
    // MARK: Deinit
    deinit {
        player.removeObserver(self, forKeyPath: "timeControlStatus")
    }
    
    // MARK: Helpers
    private func configurePlayer() {
        try? AVAudioSession.sharedInstance().setCategory(
            .playback,
            mode: .default,
            options: [.duckOthers, .allowAirPlay])
        
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func preparePlayer(with url: String) throws {
        resetPlayer()
        try configurePlayer(with: url)
    }
    
    private func configurePlayer(with url: String) throws {
        guard let url = URL(string: url) else {
            throw MusicPlayerError.audioFileNotFound
        }
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        addObservers(to: player,with: playerItem)
    }
    
    func playMusic() throws {
        guard !isPlayingCurrently() else {
            return
        }
        
        do {
            try Connectivity.checkInternetConnection()
            player.play()
        } catch {
           throw NetworkError.noConnection
        }
    }
    
    private func resetPlayer() {
        progress = 0
        removeObservers()
    }
    
    private func addObservers(to player: AVPlayer,
                              with playerItem: AVPlayerItem) {
        addTimeControlObserver(to: player)
        addProgressObserver(to: playerItem)
        
    }
    
    private func addTimeControlObserver(to player: AVPlayer) {
        player.addObserver(self,
                           forKeyPath: "timeControlStatus",
                           options: [.initial, .new],
                           context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus",
           let newRate = change?[.newKey] as? Float {
            if newRate == 1.0 {
                hasFinished = false
            } else if newRate == 0.0 {
                hasFinished = true
            }
        }
    }
    
    private func addProgressObserver(to playerItem: AVPlayerItem) {
        let interval = CMTime(seconds: 0.01,
                              preferredTimescale: CMTimeScale(NSEC_PER_MSEC))
        progressObserver = player.addPeriodicTimeObserver(
            forInterval: interval, queue: .main) { [weak self] time in
                guard let self = self else { return }
                let duration = CMTimeGetSeconds(playerItem.duration)
                let currentTime = CMTimeGetSeconds(time)
                self.progress = currentTime / duration
            }
    }
    
    private func removeObservers() {
        if let observerToken = self.progressObserver {
            player.removeTimeObserver(observerToken)
            self.progressObserver = nil
            self.player.replaceCurrentItem(with: nil)
        }
    }
    
    func pauseMusic() {
        player.pause()
    }
    
    func isPlayingCurrently() -> Bool {
        player.timeControlStatus == .playing
    }
    
    func seekTo(startAt second: Double) {
        let startTime = CMTime(seconds: second,
                               preferredTimescale: 1)
        player.seek(to: startTime)
    }
}
