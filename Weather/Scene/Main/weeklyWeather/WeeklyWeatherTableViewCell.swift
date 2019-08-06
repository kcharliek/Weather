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

    @IBOutlet weak var dateLabel: DateLabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var maximumTemperatureLabel: TemperatureLabel!
    @IBOutlet weak var minimumTemperatureLabel: TemperatureLabel!

    internal func setModel(_ model: Weather?) {
        guard let model = model else {
            return
        }

        self.setIcon(with: model)
        self.setTemperatureLabel(with: model)
        self.setDateLabel(with: model)
    }

    // MARK: - private

    private func setIcon(with model: Weather) {
        let urlString = model.fetchIconURLString()
        self.iconImageView.setImage(withUrlString: urlString, placeholder: nil)
    }

    private func setTemperatureLabel(with model: Weather) {
        self.minimumTemperatureLabel.setTemperature(model.temperatureLow)
        self.maximumTemperatureLabel.setTemperature(model.temperatureHigh)
    }

    private func setDateLabel(with model: Weather) {
        self.dateLabel.setTimeInterval(model.time, format: .dayOfTheWeek)
    }

}

