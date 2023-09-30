//
//  MainView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct MainView: View {
    
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
                    
                    SongListView(imgDimension: imgDimension)
                    .padding(.bottom, isPlaying ? playerHeight : 0)
                    
                    SongPlayerView(song: SongItem.dummySong,
                                   imgDimension: imgDimension)
                    .ignoresSafeArea(.all)
                    .frame(height: playerHeight)
                    .offset(y: isPlaying ? 0 : playerHeight*1.5)
                    .animation(.easeIn(duration: 0.3), value: isPlaying)
                    
                }
                .navigationTitle("SPreview")
            }
        }
    }
}

#Preview {
    MainView()
}
