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
                        .alert(item: $errorHandling.currentAlert) { currentAlert in
                            Alert(
                                title: Text("Error"),
                                message: Text(currentAlert.error.localizedDescription),
                                dismissButton: .default(Text("Ok")) {
                                    currentAlert.dismissAction?()
                                }
                            )
                        }
                )
        }
    }
}
