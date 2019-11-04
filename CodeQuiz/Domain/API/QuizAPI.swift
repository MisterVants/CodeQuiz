//
//  QuizAPI.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

class QuizAPI {
    
    /// The specified configuration data for the API.
    let apiConfiguration = APIConfig.makeDefault()
    private let provider: Provider
    private let defaultQuizIndex = 1
    
    init(provider: Provider = APIProvider()) {
        self.provider = provider
    }
    
    /// Gets a default quiz from the API.
    func getQuiz(completion: @escaping (Result<Quiz, Error>) -> Void) {
        let endpoint = QuizEndpoint(quizIndex: defaultQuizIndex)
        provider.request(Quiz.self, at: endpoint, config: apiConfiguration) { response in
            completion(response.result)
        }
    }
}
