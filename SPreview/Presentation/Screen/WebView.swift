//
//  WebView.swift
//  SPreview
//
//  Created by Amr on 1.10.2023.
//

import SwiftUI
import WebKit

struct WebView<Provider: MusicProvider>: UIViewRepresentable {
    
    // MARK: Properties
    let musicProvider: Provider
    private var webview: WKWebView
    
    @Binding var hasAuthorized: Bool
    
    // MARK: Init
    init(musicProvider: Provider,
         requestManager: RequestManagerProtocol,
         hasAuthorized: Binding<Bool>) {
        self.musicProvider = musicProvider
        self.webview = WKWebView()
        _hasAuthorized = hasAuthorized
    }
    
    // MARK: Functions
    func makeCoordinator() -> Coordinator<Provider> {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let request = musicProvider.getAuthorizationRequest() else {return}
        uiView.load(request)
        uiView.navigationDelegate = context.coordinator
    }
}

// MARK: Coordinator
class Coordinator<Provider: MusicProvider>: NSObject, WKNavigationDelegate {
    var parent: WebView<Provider>
    
    init(_ parent: WebView<Provider>) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let urlAbsoluteString = webView.url?.absoluteString else {return}
        parent.musicProvider.getAuthToken(from: urlAbsoluteString) {[weak self] hasRetrivedToken in
            if hasRetrivedToken {
                self?.parent.hasAuthorized = true
            }
        }
    }
}
