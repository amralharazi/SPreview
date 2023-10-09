//
//  AppDelegate.swift
//  SPreview
//
//  Created by Amr on 9.10.2023.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        SpotifyAuthController.shared.setup()
    }
}
