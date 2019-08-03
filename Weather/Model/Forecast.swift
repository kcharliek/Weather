//
//  Forecast.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal protocol Forecast: Decodable {

    var timestamp: Date { get }
    var current: Weather { get }
    var daily: [Weather] { get }
    var hourly: [Weather] { get }
    var coordinate: Coordinate { get }

}
