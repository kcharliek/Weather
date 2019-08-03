//
//  Weather.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation
import CoreLocation


internal protocol Weather: Decodable {

    var latitude: Double? { get }
    var longitude: Double? { get }
    var time: Double { get }
    var summary: String { get }
    var icon: String { get }
    var temperature: Double? { get }
    var temperatureLow: Double? { get }
    var temperatureHigh: Double? { get }
    var humidity: Double { get } // 습도
    var precipProbability: Double { get } // 강수확률
    var sunriseTime: Double? { get }
    var sunsetTime: Double? { get }
    var windSpeed: Double { get } // 풍속
    var windBearing: Double { get } // 풍향
    var pressure: Double { get } // 기압
    var visibility: Double { get } // 가시거리
    var uvIndex: Double { get } // 자외선 지수

}

extension Weather {

    var coordinate: Coordinate? {
        guard let longitude = self.longitude, let latitude = self.latitude else {
            return nil
        }
        return Coordinate(longitude: longitude, latitude: latitude)
    }

}
