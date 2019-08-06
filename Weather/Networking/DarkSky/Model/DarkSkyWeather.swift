//
//  DarkSkyWeather.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import UIKit


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

    func fetchIconURLString() -> String {
        let base = "https://darksky.net"
        let path = "/images/weather-icons"
        let ext = ".png"

        return base + path + "/" + self.icon + ext
    }

}
