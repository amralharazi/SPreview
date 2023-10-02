//
//  WebView.swift
//  SPreview
//
//  Created by Amr on 1.10.2023.
//

import SwiftUI
import WebKit

struct Webview: UIViewRepresentable {
    let request: URLRequest
    var webview: WKWebView?

    init(web: WKWebView? = WKWebView() , req: URLRequest) {
        self.webview = web
        self.request = req
    }

    class Coordinator: NSObject, WKUIDelegate {
        var parent: Webview

        init(_ parent: Webview) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let urlAbsoluteString = webView.url?.absoluteString,
                  urlAbsoluteString.contains("code=") else {return}
            if let responseWithToken = urlAbsoluteString.components(separatedBy: "code=").last,
               let token = responseWithToken.components(separatedBy: "&").first {
                
                Task {
                    let request = TokenRequest.getAuthKeys(code: token)
                    //                    let response: AccessTokens = try await requestManager.perform(request)
                    //                    try? accessManager.refreshWith(token: response)
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView  {
        return webview!
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.uiDelegate = context.coordinator
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
