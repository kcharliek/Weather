//
//  UIViewExtensions.swift
//  Weather
//
//  Created by ChanHee kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


extension UIView {

    @discardableResult
    static func fromNib() -> Self {
        func _fromNib<T: UIView>() -> T {
            return Bundle.main.loadNibNamed(T.typeName, owner: nil)?.first as! T
        }

        return _fromNib()
    }

    func autoPinEdgesToSuperview() {
        guard let _superview = self.superview else {
            return
        }

        self.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: _superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: _superview.trailingAnchor),
            self.topAnchor.constraint(equalTo: _superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: _superview.bottomAnchor)
        ])
    }

}
