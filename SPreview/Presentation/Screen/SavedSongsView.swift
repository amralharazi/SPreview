//
//  MainView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SavedSongsView: View {
    
    // MARK: Properties
    let spotifyMusic: MusicProvider
    
    @State private var songs = [SongItem]()
    @State private var isShowingLastSong = false
    @State private var tappedSong: SongItem?
    @State private var shouldAddPaddingToList = false
    @State private var isPlaying = false {
        didSet {
            if !isPlaying {
                shouldAddPaddingToList = false
            }
        }
    }
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6
            let playerHeight = imgDimension*1.5
            
            NavigationView {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 10) {
                        TitleAndSearchHeaderView()
                        
                        SongListView(imgDimension: imgDimension,
                                     songs: $songs,
                                     isShowingLastSong: $isShowingLastSong,
                                     tappedSong: $tappedSong.animation())
                        .padding(.bottom, shouldAddPaddingToList ? playerHeight : 0)
                        
                    }
                    .padding(.horizontal)
                    
                    if let song = tappedSong {
                        SongPlayerView(song: song,
                                       imgDimension: imgDimension,
                                       musicPlayer: MusicPlayer.shared)
                        .frame(height: playerHeight)
                        .offset(y: isPlaying ? 0 : playerHeight*1.5)
                        .animation(.easeIn(duration: 0.2), value: isPlaying)
                    }
                }
                .background(Color.bienso)
            }
            .toolbar(.hidden, for: .navigationBar)
            .task {
                await getSavedSongs()
            }
            .onChange(of: isShowingLastSong) { _, newValue in
                if newValue == true {
                    Task{ await getNextBatch()}
                }
            }
            .onChange(of: tappedSong) {
                if let tappedSong = tappedSong {
                    isPlaying = true
                    
                    if isPlaying {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            shouldAddPaddingToList = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Functions
    private func getSavedSongs() async {
        songs = await spotifyMusic.getSavedSongs()
    }
    
    private func getNextBatch() async {
        let newBatch = await spotifyMusic.getNextSongBatch()
        songs.append(contentsOf: newBatch)
        isShowingLastSong = false
    }
}

#Preview {
    SavedSongsView(spotifyMusic: SpotifyMusic())
}


