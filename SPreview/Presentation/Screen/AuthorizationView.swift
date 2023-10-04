//
//  AuthorizationView.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import SwiftUI

struct AuthorizationView: View {
    
    // MARK: Properties
    let musicProvider: any MusicProvider
    
    @State private var presentAuthorizationWebView = false
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
                        presentAuthorizationWebView.toggle()
                    }
                    .foregroundStyle(.white)
                    .font(.system(.headline))
                    .frame(width: width/2, height: height*0.06)
                    .background(Color.brightestPerrywinkle)
                    .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.maxCornerRadius))
                }
                .padding()
            }
            .fullScreenCover(isPresented: $presentAuthorizationWebView) {
                prepareRequestView()
                    .fullScreenCover(isPresented: $hasAuthorized) {
                        SavedSongsView(musicProvider: SpotifyMusic())
                    }
            }
        }
    }
    
    // MARK: Functions
    private func prepareRequestView() -> WebView? {
        if let request = musicProvider.getAuthorizationRequest() {
            return WebView(req: request,
                           requestManager: RequestManager(),
                           hasAuthorized: $hasAuthorized)
        }
        
        return nil
    }
}

#Preview {
    AuthorizationView(musicProvider: SpotifyMusic())
}
