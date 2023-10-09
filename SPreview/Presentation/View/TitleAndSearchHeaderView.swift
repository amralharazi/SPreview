//
//  TitleAndSearchHeaderView.swift
//  SPreview
//
//  Created by Amr on 1.10.2023.
//

import SwiftUI

struct TitleAndSearchHeaderView: View {
    
    // MARK: Properties
    @Binding var searchTerm: String
    @State private var showCancelBtn = false
    @FocusState private var isEditing
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                let itemDimension = geometry.size.height/2 - 5
                
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: itemDimension, height: itemDimension)
                
                HStack {
                    searchField
                    cancelButton
                }
                .frame(height: itemDimension)
            }
            .onChange(of: isEditing) {
                withAnimation {
                    if isEditing {
                        showCancelBtn = isEditing
                    } else {
                        showCancelBtn = false
                    }
                }
            }
        }
    }
    
    var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Search for song", text: $searchTerm)
                .focused($isEditing)
                .autocorrectionDisabled()
        }
        .padding(.vertical, DrawingConstants.minVerticalSpacing)
        .padding(.horizontal)
        .background(Color.white.opacity(0.1))
        .clipShape(
            RoundedRectangle(
                cornerRadius: DrawingConstants.minCornerRadius
            )
        )
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            searchTerm = ""
            isEditing = false
        }
        .foregroundStyle(.white)
        .offset(x: showCancelBtn ? 0 : 100)
        .frame(width: showCancelBtn ? 60: 0)
        .opacity(showCancelBtn ? 1 : 0.2)
    }
}

#Preview {
    TitleAndSearchHeaderView(searchTerm: .constant(""))
}

