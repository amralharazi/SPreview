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
    @Published var hasFinished = false
    
    // MARK: Init
    private override init() {
        super.init()
        configurePlayer()
    }
    
    // MARK: Deinit
    deinit {
        player.removeObserver(self, forKeyPath: "rate")
    }
    
    // MARK: Helpers
    private func configurePlayer() {
        try? AVAudioSession.sharedInstance().setCategory(.playback,
                                                         mode: .default,
                                                         options: [.mixWithOthers, .allowAirPlay])
        
        try? AVAudioSession.sharedInstance().setActive(true)
    }
    
    func preparePlayer(with url: String) throws {
        guard let url = URL(string: url) else {
            throw MusicPlayerError.audioFileNotFount
        }
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.addObserver(self, forKeyPath: "rate", options: .new, context: nil)

        playMusic()
    }
    
    func playMusic() {
        player.play()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if keyPath == "rate", let newRate = change?[.newKey] as? Float {
            if newRate == 1.0 {
                // Playback started
//                print("Playback started")
                hasFinished = false
            } else if newRate == 0.0 {
//                print("Playback finished.")
                hasFinished = true
            }
        }
    }
    
    func pauseMusic() {
        player.pause()
    }
    
    func isPlayingCurrently() -> Bool {
        player.timeControlStatus == .playing
    }
    
    func seekTo(startAt: CGFloat) {
        let startTimeInSeconds: Double = startAt
        let startTime = CMTime(seconds: startTimeInSeconds, preferredTimescale: 1)
        player.seek(to: startTime)
        if !isPlayingCurrently() {
            playMusic()
        }
    }

}
