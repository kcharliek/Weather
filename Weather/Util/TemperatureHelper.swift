//
//  TemperatureHelper.swift
//  Weather
//
//  Created by ChanHee Kim on 06/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal struct TemperatureHelper {

    static internal func fahrenheit(from celsius: Double) -> Double {
        return (celsius * 1.8) + 32
    }

    static internal func celsius(from fahrenheit: Double) -> Double {
        return (fahrenheit - 32) / 1.8
    }

}
