//
//  UIApplicationExtension.swift
//  SPreview
//
//  Created by Amr on 4.10.2023.
//

import UIKit.UIApplication

extension UIApplication {
    func dismissKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}
