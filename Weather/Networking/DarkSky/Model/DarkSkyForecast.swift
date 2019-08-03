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
    var daily: [Weather]
    var hourly: [Weather]
    var coordinate: Coordinate

    // MARK: - coding keys

    private enum CodingKeys: CodingKey {
        case longitude
        case latitude
        case currently
        case hourly
        case daily
    }

    private enum DataCodingKeys: CodingKey {
        case data
    }

    // MARK: - decodable

    init(from decoder: Decoder) throws {
        self.timestamp = Date()

        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.current = try container.decode(DarkSkyWeather.self, forKey: .currently)

        let dailyDataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .daily)
        self.daily = try dailyDataContainer.decode([DarkSkyWeather].self, forKey: .data)

        let hourlyDataContainer = try container.nestedContainer(keyedBy: DataCodingKeys.self, forKey: .hourly)
        self.hourly = try hourlyDataContainer.decode([DarkSkyWeather].self, forKey: .data)

        let longitude = try container.decode(Double.self, forKey: .longitude)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        self.coordinate = Coordinate(longitude: longitude, latitude: latitude)
    }

}
