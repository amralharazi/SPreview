//
//  ViewExtension.swift
//  SPreview
//
//  Created by Amr on 3.10.2023.
//

import SwiftUI

extension View {
    func withErrorHandling() -> some View {
        modifier(HandleErrorsByShowingAlertViewModifier())
    }
}
