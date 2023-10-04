//
//  MainView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SavedSongsView: View {
    
    // MARK: Properties
    let musicProvider: MusicProvider
    
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var songs = [SongItem]()
    @State private var tappedSong: SongItem?
    @State private var isShowingLastSong = false
    @State private var shouldAddPaddingToList = false
    @State private var isPlaying = false
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6
            let playerHeight = geometry.size.height/6
            
//            NavigationView {
                ZStack(alignment: .bottom) {
                    VStack(spacing: DrawingConstants.minVerticalSpacing) {
                        TitleAndSearchHeaderView()
                                                
                        SongListView(imgDimension: imgDimension,
                                     songs: $songs,
                                     tappedSong: $tappedSong.animation(),
                                     isShowingLastSong: $isShowingLastSong)
                        .padding(.bottom, shouldAddPaddingToList ? playerHeight/1.5 : 0)
                        
                        Spacer()

                        
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        Spacer()
                        
                        
                        if let song = tappedSong {
                            SongPlayerView(song: song,
                                           imgDimension: imgDimension,
                                           musicPlayer: MusicPlayer.shared)
                            .frame(height: playerHeight)
                            .offset(y: isPlaying ? 0 : playerHeight*1.5)
                            .animation(.easeInOut(duration: AnimationConstants.minDuration), value: isPlaying)
                        }
                    }

                }
                .background(Color.bienso)
                .ignoresSafeArea(edges: .bottom)

//            }
//            .toolbar(.hidden, for: .navigationBar)
            .task {
                await getSavedSongs()
            }
            .onChange(of: isShowingLastSong) { _, newValue in
                if newValue == true {
                    Task{ await getNextBatch()}
                }
            }
            .onChange(of: tappedSong) {
                changeSong()
            }
        }
    }
    
    // MARK: Functions
    private func getSavedSongs() async {
        do {
            songs = try await musicProvider.getSavedSongs()
        } catch {
            self.errorHandling.handle(error: error)
        }
        
    }
    
    private func getNextBatch() async {
        do {
            let newBatch = try await musicProvider.getNextSongBatch()
            songs.append(contentsOf: newBatch)
            isShowingLastSong = false
        } catch {
            self.errorHandling.handle(error: error)
        }
    }
    
    private func changeSong() {
        isPlaying = true
        if isPlaying {
            DispatchQueue.main.asyncAfter(deadline: .now() + AnimationConstants.minDuration) {
                shouldAddPaddingToList = true
            }
        }
    }
}

#Preview {
    SavedSongsView(musicProvider: SpotifyMusic())
}


