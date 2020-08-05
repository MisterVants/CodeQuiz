//
//  Array+Extension.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

extension Array where Array.Element == String {
    
    func containsCaseInsensitive(_ element: Element) -> Bool {
        return self.contains(where: {
            $0.caseInsensitiveCompare(element) == .orderedSame
        })
    }
}
