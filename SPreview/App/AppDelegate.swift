//
//  AppDelegate.swift
//  SPreview
//
//  Created by Amr on 9.10.2023.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil)
    -> Bool {
        SpotifyAuthController.shared.setup()
        return true
    }
}
