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
    
    @State private var isPlaying = false
    
    // MARK: Content
    var body: some View {
        ZStack {
            Color.brightestPerrywinkle
                .clipShape(.rect(topLeadingRadius: 20,
                                 topTrailingRadius: 20))
            
            VStack (alignment: .center){
                HStack(spacing: 10) {
                    SongRowView(imgDimension: 80/1.5, isForSongPlayerView: true)
                    
                    Button {
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                            .font(.system(.headline))
                            .contentTransition(.symbolEffect(.replace))
                    }
                    .tint(.white)
                }
                
                SliderView()
            }
            .padding()

        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongPlayerView(song: SongItem.dummySong, imgDimension: 80)
        .frame(height: 120)
        .padding(.top)
}
