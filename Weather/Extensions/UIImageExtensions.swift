//
//  UIImageExtensions.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


extension UIImageView {

    func setImage(withUrlString urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder

        guard let url = URL(string: urlString) else {
            return
        }

        URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
            guard let data = data else {
                return
            }

            DispatchQueue.main.async { self?.image = UIImage(data: data) }
        }).resume()
    }

}
