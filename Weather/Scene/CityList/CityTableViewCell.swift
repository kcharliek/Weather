//
//  CityTableViewCell.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit
import CoreLocation


class CityTableViewCell: UITableViewCell {

    // MARK: - IBOutlet

    
    @IBOutlet weak var temperatureLabel: TemperatureLabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeLabel: DateLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navigationImageView: UIImageView!

    // MARK: - init

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func prepareForReuse() {
        self.request?.cancel()
        self.temperatureLabel.text = "--°"
        self.nameLabel.text = "--"
        self.timeLabel.text = "-- --:--"
        self.navigationImageView.isHidden = true
    }

    // MARK: - internal

    internal func setModel(_ model: Placemark?, isFirst: Bool) {
        guard let model = model else {
            return
        }
        self.model = model

        self.navigationImageView.isHidden = (isFirst == false)
        self.timeLabel.isHidden = (isFirst == true)
        self.timeLabel.setDate(Date.now, format: .ampm_hour_minute, timeZone: model.timeZone)

        self.request = ForecastCenter.shared.requestForecast(at: model) { [weak self] (result) in
            guard let self = self else { return }
            result.handleSuccess(self.applyForecast)
        }
    }

    // MARK: - private

    private var model: Placemark?
    private var request: Cancelable?

    private func applyForecast(_ forecast: Forecast) {
        DispatchQueue.main.async {
            self.nameLabel.text = self.model?.name
            self.temperatureLabel.setTemperature(forecast.current.temperature)
        }
    }

}
