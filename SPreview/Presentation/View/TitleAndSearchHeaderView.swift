//
//  TitleAndSearchHeaderView.swift
//  SPreview
//
//  Created by Amr on 1.10.2023.
//

import SwiftUI

struct TitleAndSearchHeaderView: View {
    
    // MARK: Properties
    @State private var searchTerm = ""
    
    // MARK: Content
    var body: some View {
        VStack(alignment: .center) {
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Serach for song", text: $searchTerm)

            }
            .padding(.vertical, DrawingConstants.minVerticalSpacing)
            .padding(.horizontal)
            .background(.white.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.minCornerRadius))
            .disabled(true)
        }
    }
}

#Preview {
    TitleAndSearchHeaderView()
}

