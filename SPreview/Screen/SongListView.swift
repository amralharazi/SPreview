//
//  SongListView.swift
//  SPreview
//
//  Created by Amr on 30.09.2023.
//

import SwiftUI

struct SongListView: View {
    
    
    var body: some View {
        GeometryReader { geometry in
            let imgDimension = geometry.size.width/6

            NavigationView {
                ZStack {
                    Color.bienso
                        .ignoresSafeArea()
                    
                    VStack {
                        List(0..<10, id: \.self) { number in
                            SongRowView(imgDimension: imgDimension)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .scrollContentBackground(.hidden)
                    }
                }
                .navigationTitle("SPreview")
            }
        }
    }
}

#Preview {
    SongListView()
}
