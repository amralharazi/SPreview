//
//  SongListView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SongListView: View {
    
    // MARK: Properties
    @State private var isPlaying = false
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6
            let playerHeight = geometry.size.height/8
            
            NavigationView {
                ZStack(alignment: .bottom) {
                    Color.bienso
                        .ignoresSafeArea()
                    
                    List(0..<10, id: \.self) { number in
                        SongRowView(imgDimension: imgDimension)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .padding(.bottom, isPlaying ? playerHeight : 0)
                    .scrollIndicators(.hidden)
                    .listStyle(.plain)
                    
                    
                    SongPlayerView(song: SongItem.dummySong,
                                   imgDimension: imgDimension)
                    .ignoresSafeArea(.all)
                    .frame(height: playerHeight)
                    .offset(y: isPlaying ? 0 : playerHeight*1.5)
                    .animation(.easeIn(duration: 0.3), value: isPlaying)
                    
                }
                .navigationTitle("SPreview")
                .onAppear {
                    isPlaying = true
                }
            }
        }
    }
}

#Preview {
    SongListView()
}
