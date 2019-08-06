//
//  APITask.swift
//  Weather
//
//  Created by ChanHee Kim on 01/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation

struct DarkSkyAPI: ForecastAPI {

    static let manager: APIManager = DarkSkyAPIManager()

    static func requestForecast(at coordinate: Coordinate, completion: ForecastCompletion?) -> Cancelable {
        let request = DarkSkyFetchForecastRequest(coordinate: coordinate)
        let task = APITask<DarkSkyForecast>(request: request,
                                            manager: manager,
                                            completion: { result in
                                                completion?(result.map{ $0 as Forecast }) }
        )
        task.execute()
        return task
    }



}
