//
//  ErrorHandling.swift
//  SPreview
//
//  Created by Amr on 3.10.2023.
//

import Foundation

struct ErrorAlert: Identifiable {
    var id = UUID()
    var error: Error
    var dismissAction: (() -> Void)?
}

class ErrorHandling: ObservableObject {
    @Published var currentAlert: ErrorAlert?
    @Published var isPresented = false
    
    func handle(error: Error) {
        currentAlert = ErrorAlert(error: error)
        isPresented = true
        currentAlert?.dismissAction = { [weak self] in
            self?.isPresented = false
            self?.currentAlert = nil
        }
    }
}
