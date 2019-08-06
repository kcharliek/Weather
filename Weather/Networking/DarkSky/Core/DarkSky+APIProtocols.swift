//
//  DarkSky+APIProtocols.swift
//  Weather
//
//  Created by ChanHee Kim on 01/08/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


struct DarkSkyAPIManager: APIManager {

    var requestFactory: APIRequestFactory = DarkSkyRequstFactory()
    var requestExecuter: APIRequestExecuter = DarkSkyRequestExecuter()
    var responseValidator: APIResponseValidator = DarkSkyResponseValidator()
    var errorChecker: APIErrorChecker = DarkSkyErrorChecker()

}

enum DarkSkyError: Error {

    case unknown
    case noData
    case didFailedParseJson
    case apiError(code: Int, description: String)

}

struct DarkSkyRequstFactory: APIRequestFactory {

    func make(request: APIRequest) -> URLRequest? {
        let urlRequest = APIRequestConverter.convert(request)

        return urlRequest
    }

}

struct DarkSkyRequestExecuter: APIRequestExecuter {

    var urlSession: URLSession = URLSession.shared

    func execute(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
        let dataTask = self.urlSession.dataTask(with: request, completionHandler: completion)
        dataTask.resume()

        return dataTask
    }
    
}

extension URLSessionDataTask: Cancelable {

}

struct DarkSkyResponseValidator: APIResponseValidator {

    func validate(_ data: Data?) -> Data? {
        return data
    }

}

struct DarkSkyErrorChecker: APIErrorChecker {

    func checkError(from data: Data?) throws {
        guard let data = data else {
            throw DarkSkyError.noData
        }

        if String(data: data, encoding: .utf8) == "Not Found\n" {
            throw DarkSkyError.unknown
        }

        let decoder = JSONDecoder()
        if let errorResponse = try? decoder.decode(DarkSkyErrorResponse.self, from: data) {
            throw DarkSkyError.apiError(code: errorResponse.code,
                                        description: errorResponse.description)
        }
    }

}

private struct DarkSkyErrorResponse: Codable {

    var code: Int
    var description: String

    private enum CodingKeys: String, CodingKey {
        case code
        case description = "error"
    }

}
