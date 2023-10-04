//
//  MainView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI


struct SavedSongsView: View {
    
    // MARK: Properties
    @State var musicProvider: MusicProvider
    
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var likedSongs = [SongItem]()
    @State private var searchedSongs = [SongItem]()
    @State private var tappedSong: SongItem?
    @State private var isShowingLastSong = false
    @State private var isPlaying = false
    @State private var searchTerm = ""
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6
            let playerHeight = geometry.size.height/6
            
            NavigationView {
                ZStack(alignment: .bottom) {
                    VStack(spacing: DrawingConstants.minVerticalSpacing) {
                        TitleAndSearchHeaderView(searchTerm: $searchTerm)
                        
                        SongListView(imgDimension: imgDimension,
                                     songs: searchTerm == "" ? $likedSongs : $searchedSongs,
                                     tappedSong: $tappedSong.animation(),
                                     isShowingLastSong: $isShowingLastSong)
                        
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
                            .animation(.easeInOut(duration: AnimationConstants.minDuration), 
                                       value: isPlaying)
                        }
                    }
                }
                .background(Color.bienso)
                .ignoresSafeArea(edges: .bottom)
                
            }
            .toolbar(.hidden, for: .navigationBar)
            .onTapGesture {
                UIApplication.shared.dismissKeyboard()
            }
            .task {
                await getSavedSongs()
            }
            .onChange(of: isShowingLastSong) { _, newValue in
                if newValue == true {
                    Task{ await getNextBatch()}
                }
            }
            .onChange(of: tappedSong) {
                if isPlaying == false {
                    isPlaying = true
                }
            }
            .onChange(of: searchTerm) {
                let nonEmptyTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
                if nonEmptyTerm.isEmpty {
                    musicProvider.searchTerm = ""
                } else {
                    Task{ await searchForSongsWith(searchTerm: nonEmptyTerm)}
                }
            }
        }
    }
    
    // MARK: Functions
    private func getSavedSongs() async {
        do {
            likedSongs = try await musicProvider.getLikedSongs()
        } catch {
            self.errorHandling.handle(error: error)
        }
        
    }
    
    private func searchForSongsWith(searchTerm: String) async {
        do {
            searchedSongs = try await musicProvider.getSongsWith(searchTerm: searchTerm)
        } catch {
            self.errorHandling.handle(error: error)
        }
        
    }
    
    private func getNextBatch() async {
        do {
            let newBatch = try await musicProvider.getNextSongBatch()
            likedSongs.append(contentsOf: newBatch)
            isShowingLastSong = false
        } catch {
            self.errorHandling.handle(error: error)
        }
    }
}

#Preview {
    SavedSongsView(musicProvider: SpotifyMusic())
}


