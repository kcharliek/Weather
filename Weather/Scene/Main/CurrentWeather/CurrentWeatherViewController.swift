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

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var temperatureLabel: TemperatureLabel!

    // MARK: - internal

    internal func setModel(_ model: Weather, placemark: Placemark?) {
        self.weatherDescriptionLabel.text = model.summary
        self.temperatureLabel.setTemperature(model.temperature)
        self.locationLabel.text = placemark?.name
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
