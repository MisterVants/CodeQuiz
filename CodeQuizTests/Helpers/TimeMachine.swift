//
//  TimeMachine.swift
//  CodeQuizTests
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

class TimeMachine {
    
    private var date = Date()
    
    func travel(by timeInterval: TimeInterval) {
        date = date.addingTimeInterval(timeInterval)
    }
    
    func getDate() -> Date {
        return date
    }
}
