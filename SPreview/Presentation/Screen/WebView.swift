//
//  WebView.swift
//  SPreview
//
//  Created by Amr on 1.10.2023.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    
    // MARK: Properties
    let request: URLRequest
    var webview: WKWebView?
    let requestManager: RequestManagerProtocol
    
    @Binding var hasAuthorized: Bool
    
    // MARK: Init
    init(web: WKWebView? = WKWebView() ,
         req: URLRequest,
         requestManager: RequestManagerProtocol,
         hasAuthorized: Binding<Bool>) {
        self.webview = web
        self.request = req
        self.requestManager = requestManager
        _hasAuthorized = hasAuthorized
    }
    
    // MARK: Coordinator
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Webview
        
        init(_ parent: Webview) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print(webView.url?.absoluteString)
            guard let urlAbsoluteString = webView.url?.absoluteString,
                  urlAbsoluteString.contains("code=") else {return}
            if let responseWithToken = urlAbsoluteString.components(separatedBy: "code=").last,
               let token = responseWithToken.components(separatedBy: "&").first {
                
                Task {
                    let request = TokenRequest.getAuthKeys(code: token)
                    let response: AccessTokens = try await parent.requestManager.perform(request)
                    try? parent.requestManager.accessTokenManager.refreshWith(token: response)
                    parent.hasAuthorized = true
                }
            }
        }
    }
    
    // MARK: Functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView  {
        return webview!
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.navigationDelegate = context.coordinator
        uiView.load(request)
    }
    
    func goBack(){
        webview?.goBack()
    }
    
    func goForward(){
        webview?.goForward()
    }
    
    func reload(){
        webview?.reload()
    }
}

//#Preview {
//    WebView(url: URL(string: "https://sarunw.com/posts/swiftui-webview/")!)
//}
