//
//  APIRequest.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal protocol APIRequest {

    var method: HTTPMethod { get }
    var url: URL { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }

}

internal enum HTTPMethod: String {

    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"

}
