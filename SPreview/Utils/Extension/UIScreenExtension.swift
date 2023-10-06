//
//  UIScreenExtension.swift
//  SPreview
//
//  Created by Amr on 4.10.2023.
//

import UIKit.UIScreen

extension UIScreen {
    static var safeArea: UIEdgeInsets {
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        
        return (keyWindow?.safeAreaInsets) ?? .zero
    }
}
