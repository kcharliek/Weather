//
//  AppDelegate.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.setupStartViewController()
        return true
    }

    // MARK: - private

    private func setupStartViewController() {
        self.window?.makeKeyAndVisible()
        let mainViewController = MainViewController.loadFromNib()
        self.window?.rootViewController = mainViewController
    }

}

