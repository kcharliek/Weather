//
//  LocationManager.swift
//  Weather
//
//  Created by ChanHee Kim on 02/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation
import CoreLocation


enum LocationManagerError: Error {

    case unavailable
    case authorizationFailed
    case weakSelfViolation
    case didFailToUpdateLocation

}

private enum LocationManagerStatus {

    case unavailable
    case ready
    case updating

}

class LocationManager: NSObject {

    typealias PlacemarkCompletion = (Result<Placemark, Error>) -> Void

    static let shared = LocationManager()

    // MARK: - internal

    internal func requestCurrentPlacemark(completion: @escaping PlacemarkCompletion) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(.failure(LocationManagerError.unavailable))
            self.status = .unavailable
            return
        }

        self.completions.append(completion)

        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways else {
            completion(.failure(LocationManagerError.authorizationFailed))
            self.manager.requestWhenInUseAuthorization()
            return
        }

        if self.status == .ready {
            self.manager.startUpdatingLocation()
            self.status = .updating
        }
    }

    // MARK: - private

    private var manager = CLLocationManager()
    private var completions: [PlacemarkCompletion] = []
    private var status: LocationManagerStatus = .ready

    private override init() {
        super.init()
        self.manager.delegate = self
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }

        self.manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocation = locations.last else {
            self.completions.forEach {
                $0(.failure(LocationManagerError.didFailToUpdateLocation))
            }
            self.completions = []
            self.status = .ready
            return
        }

        let completions = self.completions
        let coordinate = Coordinate(longitude: location.coordinate.longitude,
                                    latitude: location.coordinate.latitude)
        Placemark.make(with: coordinate) { [weak self] result in
            completions.forEach { $0(result) }
            self?.completions = []
            self?.status = .ready
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completions.forEach { $0(.failure(LocationManagerError.didFailToUpdateLocation))
        }
        self.completions = []
        self.status = .ready
    }
    
}