//
//  TimeFormatterTests.swift
//  CodeQuizTests
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import XCTest

@testable import CodeQuiz

class TimeFormatterTests: XCTestCase {

    func testFormatTimestamp_Zero() {
        let time: TimeInterval = 0
        let timestamp = TimeFormatter.timestamp(from: time)
        XCTAssert(timestamp == "00:00")
    }
    
    func testFormatTimestamp_Negative() {
        let time: TimeInterval = -30
        let timestamp = TimeFormatter.timestamp(from: time)
        XCTAssert(timestamp == "00:00")
    }
    
    func testFormatTimestamp_AlmostZero() {
        let time: TimeInterval = 0.1
        let timestamp = TimeFormatter.timestamp(from: time)
        XCTAssert(timestamp == "00:01", "Time formatter should add one second to round up the displayed time")
    }
    
    func testFormatTimestamp_GameTime() {
        let time: TimeInterval = 5 * 60 - 1
        let timestamp = TimeFormatter.timestamp(from: time)
        XCTAssert(timestamp == "05:00", "Time formatter should add one second to round up the displayed time")
    }
    
    func testFormatTimestamp_ArbitraryValue() {
        let time: TimeInterval = 23 * 60 + 54
        let timestamp = TimeFormatter.timestamp(from: time)
        XCTAssert(timestamp == "23:55", "Time formatter should add one second to round up the displayed time")
    }
}
