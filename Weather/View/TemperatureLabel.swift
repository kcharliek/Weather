//
//  TemperatureLabel.swift
//  Weather
//
//  Created by ChanHee Kim on 05/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


enum TemperaturePrintType: Int, Codable {

    case celsius = 0
    case fahrenheit

}

internal class TemperatureLabel: UILabel {

    // MARK: - internal

    internal func set(temperature: Double?) {
        let rawValue: Int = Defaults.shared.value(forKey: .temperaturePrintType) ?? 0
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
            self.text = Int(TemperatureHelper.fahrenheit(from: temperature)).stringValue + "°"
        }
    }

}
