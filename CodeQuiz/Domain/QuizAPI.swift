//
//  QuizAPI.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

class QuizAPI {
    
    func getQuiz(completion: @escaping (Result<Quiz, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let quiz = self.mockQuiz()
            completion(.success(quiz))
        }
    }
    
    private func mockQuiz() -> Quiz {
        let answer = [
        "abstract",
        "assert",
        "boolean",
        "break",
        "byte",
        "case",
        "catch",
        "char",
        "class",
        "const",
        "continue",
        "default",
        "do",
        "double",
        "else",
        "enum",
        "extends",
        "final",
        "finally",
        "float",
        "for",
        "goto",
        "if",
        "implements",
        "import",
        "instanceof",
        "int",
        "interface",
        "long",
        "native",
        "new",
        "package",
        "private",
        "protected",
        "public",
        "return",
        "short",
        "static",
        "strictfp",
        "super",
        "switch",
        "synchronized",
        "this",
        "throw",
        "throws",
        "transient",
        "try",
        "void",
        "volatile",
        "while"]
        return Quiz(question: "What are all the java keywords?", answer: answer)
    }
}
