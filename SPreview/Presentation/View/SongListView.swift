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
    
    // MARK: Content
    var body: some View {
        ScrollView() {
            LazyVStack {
                ForEach(0..<100, id: \.self) { number in
                    SongRowView(imgDimension: imgDimension)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
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
    SongListView(imgDimension: 80)
}

