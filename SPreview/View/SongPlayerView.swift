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
    
    // MARK: Content
    var body: some View {
        ZStack {
            
//            Color
            
            HStack {
                Image(song.image ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(width: imgDimension/1.5)
                    .clipShape(RoundedRectangle(cornerRadius: imgDimension/10))
                
                
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongPlayerView(song: SongItem.dummySong, imgDimension: 80)
}
