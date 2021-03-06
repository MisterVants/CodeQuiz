//
//  Localized.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

/**
 A namespace for strong-typed strings, organized in a way that can leverage the use of automatic code generation tools to build the strings from a Localized.strings file.
 */
enum Localized {
    
    static let loading = Localized.string(key: "loading")
    static let start = Localized.string(key: "start")
    static let reset = Localized.string(key: "reset")
    static let placeholderText = Localized.string(key: "placeholderText")
    
    enum Error {
        static let title = Localized.string(key: "error.title")
        static let message = Localized.string(key: "error.message")
        static let action = Localized.string(key: "error.action")
    }
    
    enum Quiz {
        enum Success {
            static let title = Localized.string(key: "quiz.success.title")
            static let message = Localized.string(key: "quiz.success.message")
            static let action = Localized.string(key: "quiz.success.action")
        }
        
        enum Failure {
            static let title = Localized.string(key: "quiz.failure.title")
            static func message(_ p1: String, _ p2: String) -> String { return Localized.string(key: "quiz.failure.message", p1, p2) }
            static let action = Localized.string(key: "quiz.failure.action")
        }
    }
}

extension Localized {
    
    private static func string(key: String, value: String? = nil, table: String? = nil, _ args: CVarArg...) -> String {
        let localizedString = Bundle.main.localizedString(forKey: key, value: value, table: table)
        return String(format: localizedString, locale: Locale.current, arguments: args)
    }
}
