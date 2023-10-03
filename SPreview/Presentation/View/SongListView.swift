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
    
    @Binding var songs: [SongItem]
    @Binding var tappedSong: SongItem?
    @Binding var isShowingLastSong: Bool
    
    // MARK: Content
    var body: some View {
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
                        tappedSong = song
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .listStyle(.plain)
    }
}

#Preview {
    SongListView(imgDimension: 80,
                 songs: .constant([]),
                 tappedSong: .constant(SongItem.dummySong),
                 isShowingLastSong: .constant(false))
}

