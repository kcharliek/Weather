//
//  CurrentWeatherViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit

class CurrentWeatherViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var weatherDescriptionLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: TemperatureLabel!

    // MARK: - internal

    internal func set(model: Weather, placemark: Placemark?) {
        self.weatherDescriptionLabel.text = model.summary
        self.temperatureLabel.set(temperature: model.temperature)
        self.locationLabel.text = placemark?.name
    }

}
