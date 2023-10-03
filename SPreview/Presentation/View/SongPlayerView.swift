//
//  SongPlayerView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SongPlayerView: View {
    
    // MARK: Properties
    let song: SongItem
    let imgDimension: CGFloat
    
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @StateObject var musicPlayer: MusicPlayer
    
    @State private var isPlaying = false
    @State private var startingSecond: Double = 0
    
    // MARK: Content
    var body: some View {
        ZStack(alignment: .top) {
            Color.brightestPerrywinkle
                .clipShape(.rect(topLeadingRadius: 20,
                                 topTrailingRadius: 20))
                .shadow(radius: 5)
            
            VStack(spacing: 20){
                HStack(spacing: 10) {
                    SongRowView(song: song,
                                imgDimension: imgDimension/1.5,
                                artistNameColor: .white)
                    
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
                
                SliderView(musicPlayer: musicPlayer,
                           startingSecond: $startingSecond)
                .frame(height: 5)
            }
            .padding()
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                configurePlayer()
            }
        }
        .onChange(of: song) {
            configurePlayer()
        }
        .onChange(of: startingSecond) {
            seekTo(second: startingSecond)
        }
        .onChange(of: musicPlayer.hasFinished) {
            if musicPlayer.hasFinished ?? false  {
                isPlaying = false
            } else {
                isPlaying = true
            }
        }
    }
    
    // MARK: Functions
    private func configurePlayer() {
        guard let previewUrl = song.previewUrl else {
            self.errorHandling.handle(error: MusicProviderError.songHasNoPreview)
            return
        }
        
        prepareSong(with: previewUrl)
    }

    private func prepareSong(with url: String) {
        do {
            try musicPlayer.preparePlayer(with: url)
            resumeMusic()
        } catch {
            self.errorHandling.handle(error: error)
        }
    }
    
    private func resumeMusic() {
        do {
            try musicPlayer.playMusic()
        } catch {
            self.errorHandling.handle(error: error)
        }
    }
    
    private func togglePlayer() {
        if musicPlayer.isPlayingCurrently() {
            musicPlayer.pauseMusic()
        } else {
            resumeMusic()
        }
    }
    
    private func seekTo(second: CGFloat) {
        musicPlayer.seekTo(startAt: second)
        resumeMusic()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongPlayerView(song: SongItem.dummySong,
                   imgDimension: 80,
                   musicPlayer: MusicPlayer.shared)
    .frame(height: 120)
    .padding(.top)
}

