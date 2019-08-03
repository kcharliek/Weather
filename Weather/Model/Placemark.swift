//
//  City.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation
import CoreLocation

typealias Placemark = CLPlacemark

enum PlacemarkError: Error {

    case invalidPlacemark

}

extension Placemark {

    typealias PlacemarkResult = (Result<Placemark, Error>) -> Void

    static func make(with coordinate: Coordinate, completion: @escaping PlacemarkResult) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                completion(.failure(error))
            }
            guard let placemark = placemarks?.first else {
                completion(.failure(PlacemarkError.invalidPlacemark))
                return
            }
            completion(.success(placemark))
        }
    }

    var coordinate: Coordinate? {
        guard let coordinate = self.location?.coordinate else {
            return nil
        }

        return Coordinate(longitude: coordinate.longitude, latitude: coordinate.latitude)
    }

}

