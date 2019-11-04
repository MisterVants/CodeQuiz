//
//  APIEndpoint.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

/// A protocol to abstract an endpoints for an API
protocol APIEndpoint {
    
    /// The target's endpoint's path.
    var path: String {get}
    
    /// A list of parameters to be sent on the request.
    var parameters: [String:String] {get}
    
    /// The HTTP method for the request.
    var method: HTTPMethod {get}
}

struct QuizEndpoint: APIEndpoint {
    
    let path: String
    let parameters: [String : String] = [:]
    let method: HTTPMethod = .get
    
    init(quizIndex: Int) {
        self.path = "/quiz/\(quizIndex)"
    }
}
