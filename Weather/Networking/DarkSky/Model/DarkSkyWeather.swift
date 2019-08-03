//
//  DarkSkyWeather.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


struct DarkSkyWeather: Weather {

    var latitude: Double?

    var longitude: Double?

    var time: Double

    var summary: String

    var icon: String

    var temperature: Double?

    var temperatureLow: Double?

    var temperatureHigh: Double?

    var humidity: Double

    var precipProbability: Double

    var sunriseTime: Double?

    var sunsetTime: Double?

    var windSpeed: Double

    var windBearing: Double

    var pressure: Double

    var visibility: Double

    var uvIndex: Double


    // API에 맞게 decode
    private enum CodingKeys: String, CodingKey {

        case latitude
        case longitude
        case time
        case summary
        case icon
        case temperature
        case humidity
        case precipProbability
        case sunriseTime
        case sunsetTime
        case windSpeed
        case windBearing
        case pressure
        case visibility
        case uvIndex

    }

//    init(from decoder: Decoder) throws {
//
//    }

}
