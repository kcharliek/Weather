//
//  CitySearchTableViewCell.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit
import MapKit


class CitySearchTableViewCell: UITableViewCell {

    // MARK: - internal

    internal func set(model: MKMapItem?) {
        self.textLabel?.text = model?.placemark.name
    }

    // MARK: - private

    private var model: MKMapItem?
    
}
