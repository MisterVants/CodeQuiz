//
//  Quiz.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

struct Quiz: Codable {
    
    /// The guiding question that defines the goal of the quiz.
    let question: String
    
    /// An array containing all expected correct answers for the quiz.
    let answer: [String]
}
