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

        static var secretKey: String {
            let list = [
                "1c2cd13b27fb4d4a84344f3f033a0cec",
                "201aa5d61aa7073c6a027bfb5f972546",
                "b222e984289c5386a588c5f46aac87c3"
            ]
            let key = list[Int.random(in: 0..<list.count)]
            print("😈😈 API Key, <\(key)> Used 😈😈")
            return key
        }

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
