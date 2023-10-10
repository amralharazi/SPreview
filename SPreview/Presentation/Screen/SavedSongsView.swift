//
//  MainView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SavedSongsView<Provider: MusicProvider>: View {
    
    // MARK: Properties
    @EnvironmentObject var musicProvider: Provider
    @EnvironmentObject var errorHandling: ErrorHandling
    
    @State private var likedSongs = [SongItem]()
    @State private var searchResultSongs = [SongItem]()
    @State private var tappedSong: SongItem?
    @State private var isShowingLastSong = false
    @State private var shouldPlayerAppeare = false
    @State private var searchTerm = ""
    private var songsToDisplay: Binding<[SongItem]> {
        Binding(get: {
            searchTerm.isEmpty ? likedSongs : searchResultSongs
        }, set: { newValue in
            if searchTerm.isEmpty {
                likedSongs = newValue
            } else {
                searchResultSongs = newValue
            }
        })
    }
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6
            let playerHeight = geometry.size.height/5.5 + UIScreen.safeArea.bottom
            let headerHeight: Double = 80
            
            NavigationView {
                ZStack(alignment: .bottom) {
                    VStack(spacing: DrawingConstants.minVerticalSpacing) {
                        TitleAndSearchHeaderView(searchTerm: $searchTerm)
                            .frame(height: headerHeight)
                        
                        SongListView(imgDimension: imgDimension,
                                     songs: songsToDisplay,
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
                            .offset(y: shouldPlayerAppeare ? 0 : playerHeight)
                            .animation(.easeIn(duration: AnimationConstants.minDuration),
                                       value: shouldPlayerAppeare)
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
            .onChange(of: tappedSong) {
                shouldPlayerAppeare = tappedSong != nil
            }
            .onChange(of: isShowingLastSong) {
                if isShowingLastSong {
                    Task{ await getNextBatch()}
                }
            }
            .onChange(of: searchTerm) {
                handleChange(in: searchTerm)
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
    
    private func handleChange(in searchTerm: String) {
        let nonEmptyTerm = searchTerm.trimmingCharacters(in: .whitespacesAndNewlines)
        if nonEmptyTerm.isEmpty {
            musicProvider.cancelSearching()
        } else {
            Task{ await searchForSongsWith(searchTerm: nonEmptyTerm)}
        }
    }
    
    private func searchForSongsWith(searchTerm: String) async {
        do {
            searchResultSongs = try await musicProvider.getSongsWith(searchTerm: searchTerm)
        } catch {
            self.errorHandling.handle(error: error)
        }
    }
    
    private func getNextBatch() async {
        do {
            let newBatch = try await musicProvider.getNextSongBatch()
            if searchTerm.isEmpty {
                likedSongs.append(contentsOf: newBatch)
            } else {
                searchResultSongs.append(contentsOf: newBatch)
            }
            isShowingLastSong = false
        } catch {
            self.errorHandling.handle(error: error)
        }
    }
}

#Preview {
    SavedSongsView<SpotifyMusic>()
        .environmentObject(SpotifyMusic())
}


