//
//  HandleErrorViewModifier.swift
//  SPreview
//
//  Created by Amr on 3.10.2023.
//

import SwiftUI

struct HandleErrorViewModifier: ViewModifier {
    
    // MARK: Properties
    @StateObject var errorHandling = ErrorHandling()
    
    // MARK: Content
    func body(content: Content) -> some View {
        
        if let error = errorHandling.currentAlert?.error,
           error as? SpotifyError == SpotifyError.notAuthorized {
            AuthorizationView(musicProvider: SpotifyMusic())
        } else {
            content
                .environmentObject(errorHandling)
                .background(
                    EmptyView()
                        .alert("Error",
                               isPresented: $errorHandling.isPresented,
                               actions: {
                                   Button("Ok") {
                                       errorHandling.currentAlert?.dismissAction?()
                                   }
                               },
                               message: {
                                   Text(errorHandling.currentAlert?.error.localizedDescription ?? "")
                               }
                              )
                )
        }
    }
}
