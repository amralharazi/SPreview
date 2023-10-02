//
//  LandingView.swift
//  SPreview
//
//  Created by Amr on 2.10.2023.
//

import SwiftUI

struct LandingView: View {
    
    // MARK: Properties
    @State private var presentAuthorizationWebView = false
    
    // MARK: Content
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            
            ZStack {
                Color.bienso
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
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
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding()
            }
            .fullScreenCover(isPresented: $presentAuthorizationWebView) {
                prepareRequestView()
            }
        }
    }
    
    // MARK: Functions
    private func prepareRequestView() -> Webview? {
        guard let request = TokenRequest.getAccessTokenRequest() else {
            return nil
        }
       return Webview(req: request)
    }
}

#Preview {
    LandingView()
        .environmentObject(TokenManager.shared)
}
