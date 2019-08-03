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

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var timeLabel: DateLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navigationImageView: UIImageView!

    // MARK: - init

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        self.request?.cancel()
        self.temperatureLabel.text = "--°"
        self.backgroundImageView.image = nil
        self.nameLabel.text = "--"
        self.timeLabel.text = "-- --:--"
        self.navigationImageView.isHidden = true
    }

    // MARK: - internal

    internal func setModel(_ model: Placemark?) {
        guard let model = model else {
            return
        }
        self.model = model

        self.request = ForecastCenter.shared.requestForecast(at: model) { [weak self] (result) in
            guard let self = self else { return }
            result.handleSuccess(self.applyForecast)
        }
    }

    // MARK: - private

    private var model: Placemark?
    private var request: Cancelable?

    private func applyForecast(_ forecast: Forecast) {
//        self.nameLabel.text = forecast.location
    }

    private func convertDate(_ date: Date, for coordinate: Coordinate, completion: @escaping (Date?) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
            if let placemark = placemarks?[0], let timeZone = placemark.timeZone {
                let seconds = TimeInterval(timeZone.secondsFromGMT(for: date))
                completion(Date(timeInterval: seconds, since: date))
            } else {
                completion(nil)
            }
        }
    }

}
