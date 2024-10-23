//
//  AuthorizationView.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import SwiftUI

struct AuthorizationView<Provider: MusicProvider>: View {
    
    // MARK: Properties
    let musicProvider: Provider
    
    @State private var hasAuthorized = false
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Color.bienso
                    .ignoresSafeArea()
                
                VStack(spacing: DrawingConstants.maxVerticalSpacing) {
                    Text("Authorize access to your Spotify \nto preview songs")
                        .font(.system(.title3))
                        .multilineTextAlignment(.center)
                    
                    Button("Authorize") {
                        SpotifyAuthController.shared.authenticateSpotify()
                    }
                    .foregroundStyle(.white)
                    .font(.system(.headline))
                    .frame(width: width/2, height: height*0.06)
                    .background(Color.brightestPerrywinkle)
                    .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.maxCornerRadius))
                }
                .padding()
            }
        }
    }
}

#Preview {
    AuthorizationView(musicProvider: SpotifyMusic())
}
