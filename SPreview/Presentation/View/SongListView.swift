//
//  SongListView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SongListView: View {
    
    // MARK: Properties
    let imgDimension: CGFloat
    
    @EnvironmentObject var errorHandling: ErrorHandling

    @Binding var songs: [SongItem]
    @Binding var tappedSong: SongItem?
    @Binding var isShowingLastSong: Bool
    
    // MARK: Content
    var body: some View {
        if songs.isEmpty {
            ProgressView()
        } else {
            ScrollView() {
                LazyVStack {
                    ForEach(songs) { song in
                        SongRowView(song: song,
                                    imgDimension: imgDimension)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .onAppear {
                            if song == songs.last {
                                isShowingLastSong = true
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            addToPlayer(song: song)
                        }
                    }
                }
                Spacer(minLength: imgDimension*2)
            }
            .scrollIndicators(.hidden)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
            .listStyle(.plain)
        }
    }
    
    // MARK: Functions
    private func addToPlayer(song: SongItem) {
        guard song.previewUrl != nil else {
            self.errorHandling.handle(error: MusicProviderError.songHasNoPreview)
            return
        }
        tappedSong = song
    }
}

#Preview {
    SongListView(imgDimension: 80,
                 songs: .constant([]),
                 tappedSong: .constant(SongItem.dummySong),
                 isShowingLastSong: .constant(false))
}

