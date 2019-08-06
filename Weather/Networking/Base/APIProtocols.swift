//
//  APIProtocols.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation


internal protocol APITaskFactory {

    var manager: APIManager { get }

}

internal class APITask<Response: Decodable>: Cancelable {

    typealias APITaskCompletion = ((Result<Response, Error>) -> Void)?

    // MARK: - init

    internal init(request: APIRequest, manager: APIManager, completion: APITaskCompletion) {
        self.request = request
        self.manager = manager
        self.completion = completion
    }

    // MARK: - internal

    internal var request: APIRequest

    internal func execute() {
        self.apiTaskResult = self.manager.execute(task: self, completion: self.completion)
    }

    internal func cancel() {
        self.apiTaskResult?.cancel()
    }

    // MARK: - private

    private var apiTaskResult: Cancelable? = nil
    private var completion: APITaskCompletion
    private var manager: APIManager

}

internal protocol APIManager {

    var requestFactory: APIRequestFactory { get }
    var requestExecuter: APIRequestExecuter { get }
    var errorChecker: APIErrorChecker { get }
    var responseValidator: APIResponseValidator { get }

}

internal protocol APIRequestFactory {

    func make(request: APIRequest) -> URLRequest?

}

internal protocol Cancelable {

    func cancel()

}

internal protocol APIRequestExecuter {

    func execute(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable

}

internal protocol APIErrorChecker {

    func checkError(from data: Data?) throws

}

internal protocol APIResponseValidator {

    func validate(_ data: Data?) -> Data?

}

extension APIManager {

    func execute<Response: Decodable>(task: APITask<Response>, completion: ((Result<Response, Error>) -> Void)?) -> Cancelable? {
        guard let urlRequest = self.requestFactory.make(request: task.request) else {
            completion?(.failure(APIError.urlRequestInitializeFailed))
            return nil
        }

        return requestExecuter.execute(request: urlRequest) { (data, urlResponse, error) in
            if let error = error {
                completion?(.failure(error))
                return
            }

            do {
                try self.errorChecker.checkError(from: data)
            } catch(let error) {
                completion?(.failure(error))
                return
            }

            guard let validatedData = self.responseValidator.validate(data) else {
                completion?(.failure(APIError.dataValidationFailed))
                return
            }

            do {
                let response = try JSONDecoder().decode(Response.self, from: validatedData)
                completion?(.success(response))
            } catch(let error) {
                completion?(.failure(error))
            }
        }
    }

}
