//
//  DarkSkyConstant.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal enum DarkSkyURL {

    private enum Constant {

        static var secretKey: String = "201aa5d61aa7073c6a027bfb5f972546"
        static var base: String = "https://api.darksky.net"

    }

    static func foreCast(with coordinate: Coordinate) -> URL {
        let foreCastPath = "/forecast"
        let secretKeyPath = "/" + Constant.secretKey
        let coordinatePath = "/" + coordinate.stringValue
        let urlString = Constant.base + foreCastPath + secretKeyPath + coordinatePath

        return URL(string: urlString)!
    }

}

fileprivate extension Coordinate {

    var stringValue: String {
        return self.latitude.stringValue + "," + self.longitude.stringValue
    }

}
