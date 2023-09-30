//
//  SongRowView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SongRowView: View {
    
    // MARK: Properties
    let imgDimension: CGFloat
    let isForSongPlayerView: Bool
    
    // MARK: Init
    init(imgDimension: CGFloat, isForSongPlayerView: Bool = false) {
        self.imgDimension = imgDimension
        self.isForSongPlayerView = isForSongPlayerView
    }
    
    // MARK: Content
    var body: some View {
        HStack(spacing: 10) {
            Image("tamino")
                .resizable()
                .scaledToFill()
                .frame(width: imgDimension, height: imgDimension)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Indigo Night")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.white)
                
                Text("Tamino")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle( isForSongPlayerView ? .white : .gray.opacity(0.75))
            }
            
            Spacer()
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SongRowView(imgDimension: 80)
}
