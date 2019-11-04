//
//  Provider.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

protocol Provider {
    func request<T: Decodable>(_ type: T.Type, at target: APIEndpoint, config: APIConfig, completion: @escaping (Response<T>) -> Void)
}

extension Provider {
    
    func resolveURL(for target: APIEndpoint, config: APIConfig) -> URL? {
        var components = URLComponents()
        components.scheme = config.scheme
        components.host = config.hostName
        components.path = target.path
        components.queryItems = target.parameters.map { URLQueryItem(name: $0, value: $1) }
        return components.url
    }
}

class APIProvider: Provider {
    
    private let session: URLSession

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func request<T>(_ type: T.Type, at target: APIEndpoint, config: APIConfig, completion: @escaping (Response<T>) -> Void) where T : Decodable {
        guard let url = resolveURL(for: target, config: config) else { completion(Response(error: NetworkError.malformedUrl)); return }
        
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        
        session.dataTask(with: request) { (data, response, error) in
            completion(Response(request: request, data: data, response: response, error: error))
        }.resume()
    }
}
