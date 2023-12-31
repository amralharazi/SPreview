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
    @Environment(\.openURL) private var openURL
    
    @StateObject var musicPlayer: MusicPlayer
    
    @State private var isPlaying = false
    @State private var hasAppeared = false
    @State private var startingSecond: Double = 0
    @State private var bottomSafeAreaHeight: CGFloat = 0
    
    // MARK: Content
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .top) {
                Color.brightestPerrywinkle
                    .clipShape(.rect(topLeadingRadius: DrawingConstants.maxInnerCornerRadius,
                                     topTrailingRadius: DrawingConstants.maxInnerCornerRadius))
                    .shadow(radius: DrawingConstants.shadowRadius)
                
                VStack(spacing: DrawingConstants.maxVerticalSpacing){
                    
                    HStack(spacing: DrawingConstants.minVerticalSpacing) {
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
                        .frame(width: 40)
                    }
                    
                    SliderView(musicPlayer: musicPlayer,
                               startingSecond: $startingSecond)
                    .frame(height: 5)
                }
                .padding()
            }
            
            Color.bienso
                .clipShape(.rect(topLeadingRadius: DrawingConstants.maxCornerRadius,
                                 topTrailingRadius: DrawingConstants.maxCornerRadius))
                .shadow(radius: DrawingConstants.shadowRadius)
                .overlay(alignment: .center, content: {
                    Button("Play Song On Spotify") {
                        playSongOnSpotify()
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                })
                .frame(height: 44+bottomSafeAreaHeight)
                .offset(y: hasAppeared ? 0 : (44+bottomSafeAreaHeight))
                .animation(.easeIn, value: hasAppeared)
            
        }
        .ignoresSafeArea()
        .onAppear {
            bottomSafeAreaHeight = UIScreen.safeArea.bottom
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationConstants.minDuration) {
                configurePlayer()
                hasAppeared = true               
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
    
    private func playSongOnSpotify() {
        guard let songUrl = song.spotifyUri,
              let url = URL(string: songUrl) else {
            return
        }
        musicPlayer.pauseMusic()
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            openURL(url)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongPlayerView(song: SongItem.dummySong,
                   imgDimension: 80,
                   musicPlayer: MusicPlayer.shared)
    .frame(height: 170)
    .padding(.top)
}

