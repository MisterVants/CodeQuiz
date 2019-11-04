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
    func quizGame(_ game: QuizGame, didInsertAnswerAt index: Int)
    func quizGame(_ game: QuizGame, didChangeState newState: QuizGame.State)
    func quizGame(_ game: QuizGame, didFinishWithResult finishResult: QuizGame.FinishResult)
}

/// The core class that manages a quiz gameplay session.
class QuizGame {
    
    /// The state which a quiz game can be at.
    enum State {
        case idle
        case playing
    }
    
    /// The finish result of a game match that can end in a win (`.victory`) or a loss (`.defeat`).
    enum FinishResult {
        case victory
        case defeat
    }
    
    /// The object that acts as the delegate of the game session.
    weak var delegate: QuizGameDelegate?
    
    /// The quiz that is being played. Needs to be set before starting a game.
    private(set) var quiz: Quiz?
    
    /// An array containing all answers that were guessed correctly during a match.
    private(set) var matchedAnswers: [String] = []
    
    /// The duration of a single match, in seconds. Defaults to one minute.
    private(set) var matchDuration: TimeInterval = 60.0
    
    /// The current state of the game.
    private(set) var state: State = .idle {
        didSet { delegate?.quizGame(self, didChangeState: state) }
    }
    
    /*  NOTE: In a real-world scenario, it's good to keep track of context changes (App states, enter background, etc)
        and manipulate the timer accordingly, suspending and resuming it as needed. */
    private var gameTimer: Timer?
    private var quizDeadline: Date?
    private let now: () -> Date
    
    /// The current score achieved during a game session. After a game ends, it remains the same until a new game is started again.
    var currentScore: Int {
        matchedAnswers.count
    }
    
    /// The target score that should be hit to achieve a win condition.
    var targetScore: Int {
        quiz?.answer.count ?? 0
    }
    
    private var remainingTime: TimeInterval {
        guard let deadline = quizDeadline else { return 0.0 }
        return deadline.timeIntervalSince(now())
    }
    
    private var allAnswersAreMatching: Bool {
        guard let quiz = quiz else { return false }
        return Set(matchedAnswers.map { $0.lowercased() }) == Set(quiz.answer.map { $0.lowercased() })
    }
    
    init(dateGenerator: @escaping () -> Date = Date.init) {
        self.now = dateGenerator
    }
    
    deinit {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    /**
     Sets up the quiz that will be played. Must be called before starting any game session.
     
     As we know in advance how many answers are possible in the quiz, this method reserves
     the memory capacity needed to avoid any later reallocations during a match.
     
     - parameters:
        - quiz: The quiz that will be played the next time a match is started.
     */
    func prepareQuiz(_ quiz: Quiz) {
        self.quiz = quiz
        matchedAnswers.reserveCapacity(quiz.answer.count)
    }
    
    /**
     Starts a new quiz match.
     
     Calling this method does nothing if there is no quiz set up or if a match is already being player.
     However, if it is called passing `restart` parameter as `true`, it ignores whether a match
     is being played and forces a restart.
     
     - parameters:
        - restart: A boolean indicating to force a restart of the match.
     */
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
            self.updateTick(timer)
        }
        gameTimer?.fire()
    }
    
    /**
     Tries to guess an answer.
     
     Tries to guess an answer by making a case insensitive compare against the expected answers.
     If the answer is guessed correctly, it inserts it to the top of the list of matched answers.
     A win condition is be triggered if all answers are matching after guessing a correct answer.
     
     If this method is called while the game is not being played, it does nothing.
     
     - parameters:
        - word: The anwser that is being guessed.
     
     - returns: A boolean indicating whether the answer was guessed correctly (`true`) or not (`false`).
     */
    func matchAnswer(_ word: String) -> Bool {
        guard state == .playing, let quiz = quiz else { return false }
        
        if quiz.answer.containsCaseInsensitive(word) && !matchedAnswers.containsCaseInsensitive(word) {
            let insertIndex = 0
            matchedAnswers.insert(word, at: insertIndex)
            delegate?.quizGame(self, didInsertAnswerAt: insertIndex)
            delegate?.quizGame(self, shouldUpdateScore: currentScore)
            if allAnswersAreMatching {
                finishGame(withResult: .victory)
            }
            return true
        }
        return false
    }
    
    /**
     Forces an update cycle to be called independently of the timer's schecule.
     */
    func forceUpdate() {
        gameTimer?.fire()
    }
    
    /**
     Sets the duration for the next match.
     
     Setting the quiz duration does not affect a match that is currently being played.
     The duration is only checked when a new match is started.
     
     - parameters:
        - minutes: The minute unit of the duration.
        - seconds: The second unit of the duration. Not capped for overflow!
     */
    func setQuizDuration(minutes: Int, seconds: Int) {
        matchDuration = Double(minutes) * 60 + Double(seconds)
    }
    
    private func updateTick(_ timer: Timer) {
        delegate?.quizGame(self, shouldUpdateRemainingTime: remainingTime)
        if remainingTime <= 0 {
            timer.invalidate()
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
