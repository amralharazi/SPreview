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
    let artistNameColor: Color
    
    // MARK: Init
    init(song: SongItem,
         imgDimension: CGFloat,
         artistNameColor: Color = .gray.opacity(0.75)) {
        self.song = song
        self.imgDimension = imgDimension
        self.artistNameColor = artistNameColor
    }
    
    // MARK: Content
    var body: some View {
        HStack(spacing: DrawingConstants.minVerticalSpacing) {
            WebImage(url: URL(string: song.image ?? ""))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: imgDimension, height: imgDimension)
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.minCornerRadius))
            
            VStack(alignment: .leading, spacing: DrawingConstants.cellVerticalSpacing) {
                Text(song.songName)
                    .font(.system(.headline, design: .rounded))
                    .lineLimit(1)
                    .foregroundStyle(Color.white)
                
                Text(song.artistName ?? "Unknown")
                    .font(.system(.subheadline, design: .rounded))
                    .lineLimit(1)
                    .foregroundStyle(artistNameColor)
            }
            
            Spacer()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongRowView(song: SongItem.dummySong, imgDimension: 80)
}
