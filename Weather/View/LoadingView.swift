//
//  LoadingView.swift
//  Weather
//
//  Created by ChanHee Kim on 05/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class LoadingView: UIView {

    // MARK: - internal

    internal static func show() {
        self.shared.indicator.startAnimating()

        self.shared.alpha = 0.0
        let _superView = UIApplication.shared.keyWindow
        _superView?.addSubview(self.shared)
        _superView?.bringSubviewToFront(self.shared)

        UIView.animate(withDuration: 0.3) {
            self.shared.alpha = 1.0
        }
    }

    internal static func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shared.alpha = 0
        }, completion: { _ in
            self.shared.removeFromSuperview()
            self.shared.indicator.stopAnimating()
        })
    }

    // MARK: - private

    private static let shared: LoadingView = LoadingView()
    private let indicator = UIActivityIndicatorView(style: .whiteLarge)
    private let backgroundView: UIView

    private init() {
        let frame = UIScreen.main.bounds
        self.backgroundView = UIView(frame: frame)
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        self.backgroundView = UIView(frame: UIScreen.main.bounds)
        super.init(coder: aDecoder)
        self.setupView()
    }

    private func setupView() {
        self.backgroundColor = UIColor.clear

        self.setupBackgroundView()
        self.setupIndicator()

        self.addSubview(self.backgroundView)
        self.addSubview(self.indicator)
    }

    private func setupBackgroundView() {
        self.backgroundView.backgroundColor = .darkGray
        self.backgroundView.alpha = 0.5
    }

    private func setupIndicator() {
        self.indicator.center = self.center
    }

}
