//
//  NetworkError.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case rateLimitExceeded
    case malformedUrl
    case generalError(Error)
    case noResponse
    case badStatusCode(HTTPStatusCode)
    case inputDataNil
    case jsonDecodeFail(Error, Data)
    
    case wildcard
}
