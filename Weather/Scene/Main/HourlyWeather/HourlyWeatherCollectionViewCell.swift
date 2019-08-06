//
//  HourlyWeatherCollectionViewCell.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


class HourlyWeatherCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet

    @IBOutlet private weak var dateLabel: DateLabel!
    @IBOutlet private weak var temperatureLabel: TemperatureLabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    // MARK: - internal

    internal func set(model: Weather?, placemark: Placemark?) {
        guard let model = model else {
            return
        }

        self.dateLabel.setTimeInterval(model.time, format: .ampm_hour, timeZone: placemark?.timeZone)
        self.iconImageView.setImage(withUrlString: model.fetchIconURLString(), placeholder: nil)
        self.temperatureLabel.set(temperature: model.temperature)
    }

}
