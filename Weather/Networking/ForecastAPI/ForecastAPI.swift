//
//  ForecastAPI.swift
//  Weather
//
//  Created by ChanHee Kim on 01/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


protocol ForecastAPI {

    typealias ForecastCompletion = (Result<Forecast, Error>) -> Void

    @discardableResult
    static func requestForecast(at coordinate: Coordinate, completion: ForecastCompletion?) -> Cancelable

}
