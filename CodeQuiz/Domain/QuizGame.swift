//
//  QuizGame.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import Foundation

protocol QuizGameDelegate: AnyObject {
    func quizGame(_ game: QuizGame, shouldUpdateRemainingTime remainingTime: TimeInterval)
    func quizGame(_ game: QuizGame, shouldUpdateScore newScore: Int)
    func quizGame(_ game: QuizGame, didChangeState newState: QuizGame.State)
    func quizGame(_ game: QuizGame, didFinishWithResult finishResult: QuizGame.FinishResult)
}

class QuizGame {
    
    enum State {
        case idle
        case playing
    }
    
    enum FinishResult {
        case victory
        case defeat
    }
    
    weak var delegate: QuizGameDelegate?
    
    private(set) var quiz: Quiz?
    private(set) var matchedAnswers: [String] = []
    private(set) var matchDuration: TimeInterval = 60.0
    
    private(set) var state: State = .idle {
        didSet { delegate?.quizGame(self, didChangeState: state) }
    }
    
    private var gameTimer: Timer?
    private var quizDeadline: Date?
    private let now: () -> Date
    
    var currentScore: Int {
        matchedAnswers.count
    }
    
    var targetScore: Int {
        quiz?.answer.count ?? 0
    }
    
    private var remainingTime: TimeInterval {
        guard let deadline = quizDeadline else { return 0.0 }
        return deadline.timeIntervalSince(now())
    }
    
    private var allAnswersAreMatching: Bool {
        guard let quiz = quiz else { return false }
        return Set(matchedAnswers) == Set(quiz.answer)
    }
    
    init(dateGenerator: @escaping () -> Date = Date.init) {
        self.now = dateGenerator
    }
    
    deinit {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    func prepareQuiz(_ quiz: Quiz) {
        self.quiz = quiz
        matchedAnswers.reserveCapacity(quiz.answer.count)
    }
    
    func startQuiz(forcingRestart restart: Bool = false) {
        guard quiz != nil, (state != .playing || restart) else { return }
        
        // Resets all game-related data, notifying the delegate
        matchedAnswers.removeAll(keepingCapacity: true)
        quizDeadline = Date(timeInterval: matchDuration, since: now())
        state = .playing
        delegate?.quizGame(self, shouldUpdateScore: currentScore)
        
        // Setup timer and fire first update
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.updateTick()
        }
        gameTimer?.fire()
    }
    
    func matchAnswer(_ word: String) -> Bool {
        guard state == .playing, let quiz = quiz else { return false }
        
        if quiz.answer.contains(word) && !matchedAnswers.contains(word) {
            matchedAnswers.insert(word, at: 0)
            delegate?.quizGame(self, shouldUpdateScore: currentScore)
            if allAnswersAreMatching {
                finishGame(withResult: .victory)
            }
            return true
        }
        return false
    }
    
    func forceUpdate() {
        gameTimer?.fire()
    }
    
    func setQuizDuration(minutes: Int, seconds: Int) {
        matchDuration = Double(minutes) * Double(seconds)
    }
    
    private func updateTick() {
        delegate?.quizGame(self, shouldUpdateRemainingTime: remainingTime)
        if remainingTime <= 0 {
            finishGame(withResult: .defeat)
        }
    }
    
    private func finishGame(withResult finishResult: FinishResult) {
        gameTimer?.invalidate()
        gameTimer = nil
        state = .idle
        delegate?.quizGame(self, didFinishWithResult: finishResult)
    }
}
