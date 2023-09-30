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
    
    // MARK: Content
    var body: some View {
        HStack {
            Image("tamino")
                .resizable()
                .scaledToFit()
                .frame(width: imgDimension)
                .clipShape(RoundedRectangle(cornerRadius: imgDimension/10))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Indigo Night")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Color.white)
                
                Text("Tamino")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.gray.opacity(0.75))
            }
            
            Spacer()
        }
    }
}

#Preview {
    SongRowView(imgDimension: 80)
        .previewLayout(.sizeThatFits)
}
