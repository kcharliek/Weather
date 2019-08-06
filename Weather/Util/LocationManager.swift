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

private enum Constant {

    static let cacheExpirationTime: TimeInterval = 60

}

class LocationManager: NSObject {

    typealias PlacemarkCompletion = (Result<Placemark, Error>) -> Void

    static let shared = LocationManager()

    // MARK: - internal

    internal func requestCurrentPlacemark(cashing: Bool = true, completion: @escaping PlacemarkCompletion) {
        guard CLLocationManager.locationServicesEnabled() else {
            completion(.failure(LocationManagerError.unavailable))
            self.status = .unavailable
            return
        }

        if let cached = self.fetchCachedPlacemark() {
            completion(.success(cached))
            return
        }

        self.completions.append(completion)

        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.manager.delegate = self
            self.manager.requestWhenInUseAuthorization()
            return
        }

        guard self.isAuthorized else {
            completion(.failure(LocationManagerError.authorizationFailed))
            return
        }

        if self.status == .ready {
            self.startUpdatingLocation()
        }
    }

    // MARK: - private

    private var manager = CLLocationManager()
    private var completions: [PlacemarkCompletion] = []
    private var status: LocationManagerStatus = .ready
    private var cachedPlacemark: Placemark? {
        didSet {
            self.lastUpdateTime = .now
        }
    }
    private var lastUpdateTime: Date = .now
    private var isAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
    }

    private override init() {
        super.init()
        self.manager.delegate = self
    }

    private func startUpdatingLocation() {
        self.manager.delegate = self
        self.manager.startUpdatingLocation()
        self.status = .updating
    }

    private func stopUpdatingLocation() {
        self.manager.stopUpdatingLocation()
        self.manager.delegate = nil
    }

    private func fetchCachedPlacemark() -> Placemark? {
        guard let placemark = self.cachedPlacemark,
            self.lastUpdateTime > cacheExpirationDate
        else {
            return nil
        }

        return placemark
    }

    private var cacheExpirationDate: Date {
        return Date.now.addingTimeInterval(-Constant.cacheExpirationTime)
    }

}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            return
        }

        self.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.stopUpdatingLocation()
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
            result.handleSuccess({ self?.cachedPlacemark = $0 })
            self?.completions = []
            self?.status = .ready
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.stopUpdatingLocation()

        self.completions.forEach { $0(.failure(LocationManagerError.didFailToUpdateLocation))
        }
        self.completions = []
        self.status = .ready
    }
    
}
