//
//  GameDelegateMock.swift
//  CodeQuizTests
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation
@testable import CodeQuiz

class GameDelegateMock: QuizGameDelegate {
    
    private(set) var hasReceivedTimeUpdate = false
    private(set) var notifiedTime: TimeInterval = 60 * 60 * 24
    
    private(set) var hasReceivedScoreUpdate = false
    private(set) var notifiedScore: Int = 0
    
    private(set) var hasReceivedStateUpdate = false
    private(set) var notifiedState: QuizGame.State?
    
    private(set) var hasFinished = false
    private(set) var finishStatus: QuizGame.FinishResult?
    
    func resetState() {
        hasReceivedTimeUpdate = false
        hasReceivedScoreUpdate = false
        hasReceivedStateUpdate = false
        hasFinished = false
        
        notifiedTime = 60 * 60 * 24
        notifiedScore = 0
        notifiedState = nil
        finishStatus = nil
    }
    
    func quizGame(_ game: QuizGame, shouldUpdateRemainingTime remainingTime: TimeInterval) {
        hasReceivedTimeUpdate = true
        notifiedTime = remainingTime
    }
    
    func quizGame(_ game: QuizGame, shouldUpdateScore newScore: Int) {
        hasReceivedScoreUpdate = true
        notifiedScore = newScore
    }
    
    func quizGame(_ game: QuizGame, didChangeState newState: QuizGame.State) {
        hasReceivedStateUpdate = true
        notifiedState = newState
    }
    
    func quizGame(_ game: QuizGame, didFinishWithResult finishResult: QuizGame.FinishResult) {
        hasFinished = true
        finishStatus = finishResult
    }
}
