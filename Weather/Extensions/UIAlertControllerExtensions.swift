//
//  UIAlertControllerExtensions.swift
//  Weather
//
//  Created by ChanHee Kim on 06/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


extension UIAlertController {

    func presentOnWindow(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let targetController = UIAlertController.controllerOnWindow else {
            completion?(false)
            return
        }

        targetController.present(self, animated: animated, completion: {
            completion?(true)
        })
    }

    static func toast(_ message : String, duration: TimeInterval = 1.8) {
        guard let targetController = self.controllerOnWindow else {
            return
        }

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = .darkGray
        alert.view.alpha = 0.4
        alert.view.layer.cornerRadius = 15

        targetController.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            alert.dismiss(animated: true)
        }
    }

    private static var controllerOnWindow: UIViewController? {
        guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }

        var targetViewControlelr: UIViewController? = rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            targetViewControlelr = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            targetViewControlelr = tabBarController.selectedViewController
        }

        return targetViewControlelr?.presentedViewController ?? targetViewControlelr
    }

}
