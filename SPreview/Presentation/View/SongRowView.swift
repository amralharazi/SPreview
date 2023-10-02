//
//  SongRowView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct SongRowView: View {
    
    // MARK: Properties
    let song: SongItem
    let imgDimension: CGFloat
    let isForSongPlayerView: Bool
    
    // MARK: Init
    init(song: SongItem,
         imgDimension: CGFloat,
         isForSongPlayerView: Bool = false) {
        self.song = song
        self.imgDimension = imgDimension
        self.isForSongPlayerView = isForSongPlayerView
    }
    
    // MARK: Content
    var body: some View {
        HStack(spacing: 10) {
            WebImage(url: URL(string: song.image ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: imgDimension, height: imgDimension)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 5) {
                Text(song.songName)
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(1)
                    .foregroundStyle(Color.white)
                
                Text(song.artistName ?? "Unknown")
                    .font(.system(.subheadline, design: .rounded))
                    .lineLimit(1)
                    .foregroundStyle( isForSongPlayerView ? .white : .gray.opacity(0.75))
            }
            
            Spacer()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongRowView(song: SongItem.dummySong, imgDimension: 80)
}
