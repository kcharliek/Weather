//
//  CurrentWeatherInfoViewController.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class CurrentWeatherInfoViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet private weak var sunriseTimeLabel: DateLabel!
    @IBOutlet private weak var sunsetTimeLabel: DateLabel!
    @IBOutlet private weak var precipProbabilityLabel: UILabel!
    @IBOutlet private weak var humidityLabel: UILabel!
    @IBOutlet private weak var windLabel: UILabel!
    @IBOutlet private weak var presureLabel: UILabel!
    @IBOutlet private weak var visibilityLabel: UILabel!
    @IBOutlet private weak var uvLabel: UILabel!

    // MARK: - internal

    internal func set(model: Weather, placemark: Placemark?) {
        self.model = model

        self.sunriseTimeLabel.setTimeInterval(model.sunriseTime, format: .ampm_hour_minute, timeZone: placemark?.timeZone)
        self.sunsetTimeLabel.setTimeInterval(model.sunsetTime, format: .ampm_hour_minute, timeZone: placemark?.timeZone)
        self.precipProbabilityLabel.text = Int(model.precipProbability * 100).stringValue + "%"
        self.humidityLabel.text = Int(model.humidity * 100).stringValue + "%"
        self.windLabel.text = self.compass(from: model.windBearing) + " " + model.windSpeed.stringValue + "m/s"
        self.presureLabel.text = Int(model.pressure).stringValue + "hPa"
        self.visibilityLabel.text = String(format: "%.1f", model.visibility) + "km"
        self.uvLabel.text = model.uvIndex.stringValue
    }

    // MARK: - private

    private var model: Weather?

    private func compass(from windBearing: Double) -> String {
        let compassValue = Int(floor((windBearing / 22.5) + 0.5))
        let compass = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE", "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
        let compassIndex = compassValue % 16

        return compass[safe: compassIndex] ?? "--";
    }

}
