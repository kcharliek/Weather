//
//  DarkSkyForecast.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal struct DarkSkyForecast: Forecast {

    // MARK: - interanl

    var timestamp: Date
    var current: Weather
    var weekly: [Weather]
    var hourly: [Weather]
    var coordinate: Coordinate

    // MARK: - coding keys

    private enum CodingKeys: String, CodingKey {
        case longitude
        case latitude
        case currently
        case hourly
        case weekly = "daily"
    }

    private enum DataCodingKeys: CodingKey {
        case data
    }

    // MARK: - decodable

    init(from decoder: Decoder) throws {
        self.timestamp = Date()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        let weeklyDataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .weekly)
        self.weekly = try weeklyDataContainer.decode([DarkSkyWeather].self, forKey: .data)

        self.current = try container.decode(DarkSkyWeather.self, forKey: .currently)
        self.current.sunriseTime = self.weekly.first?.sunriseTime
        self.current.sunsetTime = self.weekly.first?.sunsetTime

        let hourlyDataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .hourly)
        self.hourly = try hourlyDataContainer.decode([DarkSkyWeather].self, forKey: .data)

        let longitude = try container.decode(Double.self, forKey: .longitude)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        self.coordinate = Coordinate(longitude: longitude, latitude: latitude)
    }

}
