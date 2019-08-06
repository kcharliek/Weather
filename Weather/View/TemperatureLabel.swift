//
//  TemperatureLabel.swift
//  Weather
//
//  Created by ChanHee Kim on 05/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


enum TemperaturePrintType: Int, Codable {

    case fahrenheit = 0
    case celsius

}

internal class TemperatureLabel: UILabel {

    // MARK: - internal

    internal func setTemperature(_ temperature: Double?) {
        let rawValue: Int = Defaults.value(forKey: .temperaturePrintType) ?? 0
        let printType = TemperaturePrintType(rawValue: rawValue) ?? .celsius
        self.setTemperature(temperature, printType: printType)
    }

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.registerNotification()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.registerNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - private

    private var temperature: Double?

    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidChangeTemperaturePrintTypeNotification(_:)), name: .didChangeTemperaturePrintType, object: nil)
    }

    @objc
    private func handleDidChangeTemperaturePrintTypeNotification(_ notification: Notification) {
        guard let printType = notification.object as? TemperaturePrintType else {
            return
        }

        self.setTemperature(self.temperature, printType: printType)
    }

    private func setTemperature(_ temperature: Double?, printType: TemperaturePrintType) {
        guard let temperature = temperature else {
            self.text = "--°"
            return
        }
        self.temperature = temperature

        switch printType {
        case .celsius:
            self.text = Int(temperature).stringValue + "°"
        case .fahrenheit:
            self.text = Int(self.celsiusToFahrenheit(temperature)).stringValue + "°"
        }
    }

    private func celsiusToFahrenheit(_ celsius: Double) -> Double {
        return (celsius * 1.8) + 32
    }

    private func fahrenheitToCelsius(_ fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / 1.8
    }

}
