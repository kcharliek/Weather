//
//  ForecastCenter.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


private enum Constant {

    static let cacheExpirationTime: TimeInterval = 60 * 2
    static let api: ForecastAPI.Type = DarkSkyAPI.self

}

enum ForecastCenterError: Error {

    case invalidPlacemark
    case weakSelfViolation

}

internal class ForecastCenter {

    static let shared = ForecastCenter()

    // MARK: - internal

    @discardableResult
    internal func requestForecast(at placemark: Placemark, caching: Bool = true, completion: @escaping (Result<Forecast, Error>) -> Void) -> Cancelable? {
        if caching, let cached = self.fetchCachedForecast(at: placemark) {
            completion(.success(cached))
            return nil
        }

        return self.api.requestForecast(at: placemark.coordinate) { [weak self] (result) in
            guard let self = self else {
                completion(.failure(ForecastCenterError.weakSelfViolation))
                return
            }

            result.handleSuccess({ self.cachedForecast[placemark] = $0 })
            completion(result)
        }
    }

    // MARK: - private

    private var cachedForecast: [Placemark: Forecast] = [:]
    private var api: ForecastAPI.Type = Constant.api

    private init() { }

    private func fetchCachedForecast(at placemark: Placemark) -> Forecast? {
        guard let forecast = self.cachedForecast[placemark],
            forecast.timestamp > cacheExpirationDate
        else {
            return nil
        }

        return forecast
    }

    private var cacheExpirationDate: Date {
        return Date.now.addingTimeInterval(-Constant.cacheExpirationTime)
    }

}
