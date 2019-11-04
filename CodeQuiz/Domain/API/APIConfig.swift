//
//  APIConfig.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

/// A structure containing configuration data for an API. Can be extended to provide extra functionality.
struct APIConfig {
    
    /// The HTTP scheme component of the API.
    let scheme: String
    
    /// The HTTP host component of the API.
    let hostName: String
    
    /*
     NOTE: In a real-world scenarion, it would be better to keep this data in a xcconfig file to
     allow control over different build configurations to point to different API environments,
     like production and development, and avoid data problems in critical environments.
     */
    static func makeDefault() -> APIConfig {
        return APIConfig(scheme: "https", hostName: "codechallenge.arctouch.com")
    }
}
