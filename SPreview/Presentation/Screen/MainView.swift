//
//  MainView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct MainView: View {
    
    // MARK: Properties
    @State private var isPlaying = true {
        didSet {
            if !isPlaying {
                shouldAddPaddingToList = false
            }
        }
    }
    @State private var shouldAddPaddingToList = true
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6
            let playerHeight = imgDimension*1.5
            
            NavigationView {
                ZStack(alignment: .bottom) {
                    Color.bienso
                        .ignoresSafeArea(edges: .all)
                        
                    
                    SongListView(imgDimension: imgDimension)
                    .padding(.bottom, shouldAddPaddingToList ? playerHeight : 0)
                    .onTapGesture {
                        isPlaying.toggle()
                        if isPlaying {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                shouldAddPaddingToList = true
                            }
                        }
                    }
                    
                    SongPlayerView(song: SongItem.dummySong,
                                   imgDimension: imgDimension)
                    .frame(height: playerHeight)
                    .offset(y: isPlaying ? 0 : playerHeight*1.5)
                    .animation(.easeIn(duration: 0.2), value: isPlaying)
                    
                }
                .navigationTitle("SPreview")
            }
        }
    }
}

#Preview {
    MainView()
}
