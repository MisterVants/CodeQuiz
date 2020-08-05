//
//  TimeFormatter.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

enum TimeFormatter {
    
    private static let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    static func timestamp(from interval: TimeInterval) -> String {
        let nonNegativeInterval = interval > 0 ? interval + 1.0 : 0.0
        return formatter.string(from: nonNegativeInterval) ?? "00:00"
    }
}
