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

        self.setupStartRootViewController()
        return true
    }

    // MARK: - private

    private func setupStartRootViewController() {
        self.window?.makeKeyAndVisible()
        let mainVC = MainViewController.loadFromNib()
        self.window?.rootViewController = mainVC
    }

}

