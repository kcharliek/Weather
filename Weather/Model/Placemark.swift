//
//  City.swift
//  Weather
//
//  Created by ChanHee Kim on 03/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit


struct Placemark: Hashable, Codable, Equatable {

    var coordinate: Coordinate
    var name: String
    var timeZone: TimeZone

}

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
            guard let placemark = Placemark.make(clPlacemark: placemarks?.first) else {
                completion(.failure(PlacemarkError.invalidPlacemark))
                return
            }
            completion(.success(placemark))
        }
    }

    static func make(mapItem: MKMapItem?) -> Placemark? {
        guard
            let mapItem = mapItem,
            let location = mapItem.placemark.location,
            let name = mapItem.placemark.name,
            let timeZone = mapItem.timeZone
        else {
                return nil
        }

        let coordinate = Coordinate(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        return Placemark(coordinate: coordinate, name: name, timeZone: timeZone)
    }

    static func make(clPlacemark: CLPlacemark?) -> Placemark? {
        guard
            let clPlacemark = clPlacemark,
            let location = clPlacemark.location,
            let name = clPlacemark.name,
            let timeZone = clPlacemark.timeZone
        else {
                return nil
        }

        let coordinate = Coordinate(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
        return Placemark(coordinate: coordinate, name: name, timeZone: timeZone)
    }

}

