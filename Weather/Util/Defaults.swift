//
//  Defaults.swift
//  Weather
//
//  Created by ChanHee Kim on 04/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal struct Defaults {

    static let shared = Defaults()

    internal enum Key: String {
        case cities
        case temperaturePrintType
    }

    internal var userDefaults: UserDefaults = .standard

    internal func set<T: Codable>(object: T, forKey key: Defaults.Key) {
        if self.isPrimitive(T.self) {
            self.userDefaults.setValue(object, forKey: key.rawValue)
            return
        }

        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(object) else {
            return
        }

        self.userDefaults.set(encoded, forKey: key.rawValue)
    }

    internal func value<T: Codable>(forKey key: Defaults.Key) -> T? {
        if self.isPrimitive(T.self) {
            return self.userDefaults.value(forKey: key.rawValue) as? T
        }

        guard let data = self.userDefaults.data(forKey: key.rawValue) else {
            return nil
        }

        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }

    private func isPrimitive<T>(_ value: T.Type) -> Bool {
        return value is Int.Type || value is Double.Type || value is String.Type || value is Float.Type || value is Bool.Type
    }

    private init() {
        
    }

}
