//
//  WeeklyWeatherTableViewCell.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class WeeklyWeatherTableViewCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var dateLabel: DateLabel!
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var maximumTemperatureLabel: TemperatureLabel!
    @IBOutlet private weak var minimumTemperatureLabel: TemperatureLabel!

    internal func set(model: Weather?) {
        guard let model = model else {
            return
        }

        self.setupIconImageView(with: model)
        self.setupTemperatureLabel(with: model)
        self.setupDateLabel(with: model)
    }

    // MARK: - private

    private func setupIconImageView(with model: Weather) {
        let urlString = model.fetchIconURLString()
        self.iconImageView.setImage(withUrlString: urlString, placeholder: nil)
    }

    private func setupTemperatureLabel(with model: Weather) {
        self.minimumTemperatureLabel.set(temperature: model.temperatureLow)
        self.maximumTemperatureLabel.set(temperature: model.temperatureHigh)
    }

    private func setupDateLabel(with model: Weather) {
        self.dateLabel.setTimeInterval(model.time, format: .dayOfTheWeek)
    }

}

