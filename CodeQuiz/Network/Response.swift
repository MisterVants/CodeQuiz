//
//  Response.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

class Response<T: Decodable> {
    
    /// The raw data that returned in a response.
    let data: Data?
    
    /// The request associated with the response.
    let request: URLRequest?
    
    /// The response that returned from the URL load request as a URLResponse.
    let urlResponse: URLResponse?
    
    /// If a URL load request returned with an error, it is captured as an `underlyingError`.
    let underlyingError: Error?
    
    /// The response that returned from the URL load request as a HTTPURLResponse.
    var httpResponse: HTTPURLResponse? {
        urlResponse as? HTTPURLResponse
    }
    
    /// All HTTP header fields associated with the response.
    var httpHeaders: [AnyHashable : Any] {
        return httpResponse?.allHeaderFields ?? [:]
    }
    
    /// The final result of the request, containing either a decoded model or an error.
    lazy private(set) var result: Result<T, Error> = {
        let result = Self.validate(data, urlResponse, underlyingError).flatMap { validData -> Result<T, Error> in
            if let rawData = validData as? T {
                return .success(rawData)
            }
            return Self.decode(validData)
        }
        return result
    }()
    
    init(request: URLRequest? = nil, data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.request = request
        self.urlResponse = response
        self.underlyingError = error
    }
    
    private static func validate(_ data: Data?, _ urlResponse: URLResponse?, _ error: Error?) -> Result<Data, Error> {
        if let error = error {
            return .failure(NetworkError.generalError(error))
        }
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            return .failure(NetworkError.noResponse)
        }
        guard HTTPStatusCode.isSuccess(httpResponse.statusCode) else {
            return .failure(NetworkError.badStatusCode(HTTPStatusCode(code: httpResponse.statusCode)))
        }
        guard let validData = data else {
            return .failure(NetworkError.inputDataNil)
        }
        return .success(validData)
    }
    
    private static func decode<T: Decodable>(_ data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch let jsonError {
            return .failure(NetworkError.jsonDecodeFail(jsonError, data))
        }
    }
}
