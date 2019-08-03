//
//  Result.swift
//  Weather
//
//  Created by ChanHee Kim on 31/07/2019.
//  Copyright © 2019 ChanHee Kim. All rights reserved.
//

import Foundation

#if swift(<5)

public enum Result<Success, Failure> where Failure : Error {

    case success(Success)
    case failure(Failure)

    @discardableResult
    public func map<NewSuccess>(_ transform: (Success) -> NewSuccess) -> Result<NewSuccess, Failure> {
        switch self {
        case .success(let value):
            return .success(transform(value))
        case .failure(let error):
            return .failure(error)
        }
    }

}

#endif

extension Result {

    @discardableResult
    func handleSuccess(_ handler: (Success) -> Void) -> Result<Success, Failure> {
        switch self {
        case .success(let value):
            handler(value)
        case .failure(_):
            ()
        }
        return self
    }

    @discardableResult
    func handleFailure(_ handler: (Failure) -> Void) -> Result<Success, Failure> {
        switch self {
        case .success(_):
            ()
        case .failure(let error):
            handler(error)
        }
        return self
    }

}
