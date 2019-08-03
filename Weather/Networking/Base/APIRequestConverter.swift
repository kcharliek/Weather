//
//  APIRequestConverter.swift
//  Weather
//
//  Created by ChanHee Kim on 01/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal struct APIRequestConverter {

    static func convert(_ request: APIRequest) -> URLRequest? {
        var result: URLRequest

        if request.method == .get {
            guard let getURL = self.generateGetURL(from: request) else {
                return nil
            }
            result = URLRequest(url: getURL)
        } else {
            result = URLRequest(url: request.url)
            result.httpBody = try? JSONSerialization.data(withJSONObject: request.parameters, options: .prettyPrinted)
        }

        result.httpMethod = request.method.rawValue
        request.headers.forEach {
            result.addValue($1, forHTTPHeaderField: $0)
        }

        return result
    }

    static private func generateGetURL(from request: APIRequest) -> URL? {
        var comp = URLComponents(url: request.url, resolvingAgainstBaseURL: false)
        comp?.queryItems = request.parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        return comp?.url
    }

}
