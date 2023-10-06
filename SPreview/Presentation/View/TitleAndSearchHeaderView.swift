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
        VStack(alignment: .center) {
            
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            HStack {
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    TextField("Serach for song", text: $searchTerm)
                        .focused($isEditing)
                        .autocorrectionDisabled()
                    
                }
                .padding(.vertical, DrawingConstants.minVerticalSpacing)
                .padding(.horizontal)
                .background(.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.minCornerRadius))
                
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

#Preview {
    TitleAndSearchHeaderView(searchTerm: .constant(""))
}

