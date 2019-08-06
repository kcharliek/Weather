//
//  CityTableFooterView.swift
//  Weather
//
//  Created by ChanHee Kim on 05/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


internal protocol CityTableFooterViewDelegate: class {

    func cityTableFooterViewDidClickAddButton(_ cityTableFooterView: CityTableFooterView)

}

internal class CityTableFooterView: UIView {

    // MARK: - IBOutlet

    @IBOutlet weak var celsiusButton: UIButton!
    @IBOutlet weak var fahrenheitButton: UIButton!

    // MARK: - internal

    internal weak var delegate: CityTableFooterViewDelegate?

    // MARK: - init

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTemperaturePrintTypeButtonSelection()
    }

    // MARK: - actions

    @IBAction func onClickCelsiusButton(_ sender: UIButton) {
        self.temperatureButtons.forEach { $0.isSelected = false }
        sender.isSelected = true

        NotificationCenter.default.post(name: .didChangeTemperaturePrintType, object: TemperaturePrintType.celsius)
        Defaults.set(object: TemperaturePrintType.celsius.rawValue, forKey: .temperaturePrintType)
    }

    @IBAction func onClickFahrenheitButton(_ sender: UIButton) {
        self.temperatureButtons.forEach { $0.isSelected = false }
        sender.isSelected = true

        NotificationCenter.default.post(name: .didChangeTemperaturePrintType, object: TemperaturePrintType.fahrenheit)
        Defaults.set(object: TemperaturePrintType.fahrenheit.rawValue, forKey: .temperaturePrintType)
    }

    @IBAction func onClickAddButton(_ sender: Any) {
        self.delegate?.cityTableFooterViewDidClickAddButton(self)
    }

    // MARK: - private

    private var temperatureButtons: [UIButton] {
        return [self.celsiusButton, self.fahrenheitButton]
    }

    private func setupTemperaturePrintTypeButtonSelection() {
        self.temperatureButtons.forEach({ $0.isSelected = false })

        let rawValue: Int = Defaults.value(forKey: .temperaturePrintType) ?? 0
        let printType = TemperaturePrintType(rawValue: rawValue) ?? .celsius

        switch printType {
        case .celsius:
            self.celsiusButton.isSelected = true
        case .fahrenheit:
            self.fahrenheitButton.isSelected = true
        }
    }
    
}
