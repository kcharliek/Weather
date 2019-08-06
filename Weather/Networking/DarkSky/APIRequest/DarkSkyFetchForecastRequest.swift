//
//  DarkSkyFetchForecastRequest.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal struct DarkSkyFetchForecastRequest: APIRequest {

    // MARK: - RequestDescribing

    var method: HTTPMethod = .get
    var url: URL {
        return DarkSkyURL.foreCast(with: self.coordinate)
    }
    var parameters: [String : Any] {
        return ["units":"si"]
    }
    var headers: [String : String] {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }

    // MARK: - init

    init(coordinate: Coordinate) {
        self.coordinate = coordinate
    }

    // MARK: - private

    private var coordinate: Coordinate

}
