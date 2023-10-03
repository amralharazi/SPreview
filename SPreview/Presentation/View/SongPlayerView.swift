//
//  SongPlayerView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SongPlayerView: View {
    
    // MARK: Properties
    var song: SongItem?
    let imgDimension: CGFloat
   @StateObject var musicPlayer: MusicPlayer
    
    @State private var isPlaying = false
    @State private var startAnimating = false
    @State private var reset = false
    @State private var seekToSecond: CGFloat = 0

    // MARK: Content
    var body: some View {
        ZStack(alignment: .top) {
            Color.brightestPerrywinkle
                .clipShape(.rect(topLeadingRadius: 20,
                                 topTrailingRadius: 20))
                .shadow(radius: 5)
            
            VStack(spacing: 20){
                HStack(spacing: 10) {
                    SongRowView(song: song ?? SongItem.dummySong,
                                imgDimension: imgDimension/1.5,
                                isForSongPlayerView: true)
                    
                    Button {
                        togglePlayer()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(.headline))
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .tint(.white)
                    .frame(width: 30)
                }
                
                SliderView(startAnimating: $startAnimating,
                           reset: $reset,
                           seekToSecond: $seekToSecond)
                    .frame(height: 5)
            }
            .padding()
        }
        .ignoresSafeArea()
        .onAppear {
                if song != nil {
                    prepareAndPlaySong()
                    reset = true
                }
            }
        .onChange(of: song) {
            prepareAndPlaySong()
            reset = true
        }
        .onChange(of: seekToSecond) {
            seekTo(second: seekToSecond)
        }
        .onChange(of: musicPlayer.hasFinished) {
            if musicPlayer.hasFinished {
               isPlaying = false
                startAnimating = false
            } else {
                isPlaying = true
                startAnimating = true
            }
        }
    }
    
    // MARK: Functions
    private func prepareAndPlaySong() {
        if let previewUrl = song?.previewUrl {
            do {
                try musicPlayer.preparePlayer(with: previewUrl)
                isPlaying = true
                startAnimating = true
            } catch {
                print(error)
                //                delegate?.showPopup(with: error.localizedDescription)
            }
        } else {
            //            delegate?.showPopup(with: MusicProviderError.songHasNoPreview.localizedDescription)
        }
    }
    
    private func togglePlayer() {
        
        if musicPlayer.isPlayingCurrently() {
            musicPlayer.pauseMusic()
            startAnimating = false
            isPlaying = false
        } else {
            musicPlayer.playMusic()
            startAnimating = true
            isPlaying = true
        }
    }
    
    private func seekTo(second: CGFloat) {
        musicPlayer.seekTo(startAt: second)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongPlayerView(song: SongItem.dummySong,
                   imgDimension: 80,
                   musicPlayer: MusicPlayer.shared)
    .frame(height: 120)
    .padding(.top)
}

