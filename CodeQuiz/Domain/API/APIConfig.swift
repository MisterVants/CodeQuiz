//
//  APIConfig.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

struct APIConfig {
    
    /// The HTTP scheme component of the API.
    let scheme: String
    
    /// The HTTP host component of the API.
    let hostName: String
    
    static func makeDefault() -> APIConfig {
        return APIConfig(scheme: "https", hostName: "codechallenge.arctouch.com")
    }
}
