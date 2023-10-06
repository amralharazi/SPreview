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
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .top) {
                Color.brightestPerrywinkle
                    .clipShape(.rect(topLeadingRadius: 16,
                                     topTrailingRadius: 16))
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
                    Button("Play Song Instead") {
                        if let url = song.spotifyUri {
                            print(url)
                            guard let url = URL(string: url) else {
                              return 
                            }

                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            } else {
                                UIApplication.shared.openURL(url)
                            }

                        }
                    }
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .offset(y: -5)
                })
                .frame(height: 44+UIScreen.safeArea.bottom)
            
        }
        .ignoresSafeArea()
        .onAppear {
//            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationConstants.minDuration) {
//                configurePlayer()
//            }
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
    .frame(height: 170)
    .padding(.top)
}

