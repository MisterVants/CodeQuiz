//
//  QuizGameTests.swift
//  CodeQuizTests
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import XCTest

@testable import CodeQuiz

extension Double {
    func isEqual(to value: Double, upToDecimalDigits decimalDigits: Int) -> Bool {
        let powerOfTen = Double(truncating: pow(10, decimalDigits) as NSNumber)
        return Int(self * powerOfTen) == Int(value * powerOfTen)
    }
}

class QuizGameTests: XCTestCase {

    static var quizStub: Quiz?
    
    var preparedGame: QuizGame!
    var gameDelegate: GameDelegateMock!
    var timeMachine: TimeMachine!
    
    override class func setUp() {
        guard let quiz: Quiz = try? StubHelper().stub(fromJSON: "quizStub") else { XCTFail("Stub JSON file not found"); return }
        guard !quiz.answer.isEmpty else { XCTFail("Test data is empty"); return }
        quizStub = quiz
    }
    
    override func setUp() {
        super.setUp()
        timeMachine = TimeMachine()
        preparedGame = QuizGame(dateGenerator: timeMachine.getDate)
        gameDelegate = GameDelegateMock()
        
        guard let quiz = Self.quizStub else { XCTFail("Test data in nil"); return }
        preparedGame.delegate = gameDelegate
        preparedGame.prepareQuiz(quiz)
    }

    override func tearDown() {
        preparedGame = nil
        gameDelegate = nil
        timeMachine = nil
        super.tearDown()
    }
    
    // MARK: Game Start Lifecycle Tests
    
    func testStartGame() {
        preparedGame.startQuiz()
        
        XCTAssert(preparedGame.state == .playing, "The game should start playing.")
        XCTAssert(preparedGame.currentScore == 0, "Score should be set to zero.")
        XCTAssert(gameDelegate.hasReceivedScoreUpdate, "The delegate should be notified about a score update.")
        XCTAssert(gameDelegate.hasReceivedStateUpdate, "The delegate should be notified about a state update.")
        XCTAssert(gameDelegate.hasReceivedTimeUpdate, "The delegate should be notified that the timer has started.")
    }
    
    func testStartGame_WhenRunning_NeedsExplicitCallToRestart() {
        let targetAnswer = preparedGame.quiz?.answer.first ?? ""
        preparedGame.startQuiz()
        
        _ = preparedGame.matchAnswer(targetAnswer)
        gameDelegate.resetState()
        preparedGame.startQuiz(forcingRestart: true)
        
        XCTAssert(preparedGame.matchedAnswers.isEmpty, "Restarting the game cleans all correct answers.")
        XCTAssert(preparedGame.currentScore == 0, "Score should be set to zero.")
        XCTAssert(gameDelegate.hasReceivedScoreUpdate)
        XCTAssert(gameDelegate.hasReceivedStateUpdate)
        
        XCTAssert(gameDelegate.hasReceivedTimeUpdate)
    }
    
    func testStartGame_WhenRunning_DoesNothing() {
        let targetAnswer = preparedGame.quiz?.answer.first ?? ""
        preparedGame.startQuiz()
        
        _ = preparedGame.matchAnswer(targetAnswer)
        gameDelegate.resetState()
        preparedGame.startQuiz()
        
        XCTAssertFalse(preparedGame.matchedAnswers.isEmpty, "The game's state should remain the same.")
        XCTAssert(preparedGame.currentScore > 0, "Score should not reset.")
        XCTAssertFalse(gameDelegate.hasReceivedScoreUpdate)
        XCTAssertFalse(gameDelegate.hasReceivedStateUpdate)
        XCTAssertFalse(gameDelegate.hasReceivedTimeUpdate)
    }
    
    // MARK: Game Finish Conditions Tests
    
    func testFinishGame_WinWhenAllAnswersMatch() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        
        preparedGame.quiz?.answer.forEach { _ = preparedGame.matchAnswer($0) }
        
        XCTAssertTrue(gameDelegate.hasFinished, "The delegate should be notified when the game finishes.")
        XCTAssert(gameDelegate.finishStatus == .victory)
        XCTAssert(preparedGame.state == .idle, "The game should return to its idle state upon finishing.")
    }
    
    func testFinishGame_LoseWhenTimeRunsOut_NoAnswers() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        
        timeMachine.travel(by: preparedGame.matchDuration + 1)
        preparedGame.forceUpdate()
        
        XCTAssertTrue(gameDelegate.hasFinished)
        XCTAssert(preparedGame.matchedAnswers.isEmpty)
        XCTAssert(gameDelegate.finishStatus == .defeat)
        XCTAssert(preparedGame.state == .idle, "The game should return to its idle state upon finishing.")
    }
    
    func testFinishGame_LoseWhenTimeRunsOut_WithSomeAnswer() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        let answer = preparedGame.quiz?.answer.first ?? ""
        
        _ = preparedGame.matchAnswer(answer)
        timeMachine.travel(by: preparedGame.matchDuration + 1)
        preparedGame.forceUpdate()
        
        XCTAssertTrue(gameDelegate.hasFinished)
        XCTAssertFalse(preparedGame.matchedAnswers.isEmpty)
        XCTAssert(gameDelegate.finishStatus == .defeat)
        XCTAssert(preparedGame.state == .idle, "The game should return to its idle state upon finishing.")
    }
    
    func testFinishGame_LoseWhenTimeRunsOut_MissingLastAnswer() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        let almostAllAnwsers = preparedGame.quiz?.answer.dropLast() ?? []
        
        almostAllAnwsers.forEach { _ = preparedGame.matchAnswer($0) }
        timeMachine.travel(by: preparedGame.matchDuration + 1)
        preparedGame.forceUpdate()
        
        XCTAssertTrue(gameDelegate.hasFinished)
        XCTAssert(gameDelegate.finishStatus == .defeat)
        XCTAssert(preparedGame.state == .idle, "The game should return to its idle state upon finishing.")
    }
    
    // MARK: Quiz Matching Tests
    
    func testMatchAnswer_success() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        let targetAnswer = preparedGame.quiz?.answer.first ?? ""
        
        let answerMatches = preparedGame.matchAnswer(targetAnswer)
        
        XCTAssertTrue(answerMatches)
        XCTAssert(preparedGame.matchedAnswers.contains(targetAnswer), "A correct answer should be added to the list.")
        XCTAssert(gameDelegate.hasReceivedScoreUpdate, "The delegate should be notified about a score update.")
        XCTAssert(gameDelegate.notifiedScore == preparedGame.currentScore)
    }
    
    func testMatchAnswer_successOrdering() {
        let targetAnswerA = preparedGame.quiz?.answer.first ?? ""
        let targetAnswerB = preparedGame.quiz?.answer.last ?? ""
        assert(targetAnswerA != targetAnswerB)
        preparedGame.startQuiz()
        
        _ = preparedGame.matchAnswer(targetAnswerA)
        XCTAssert(preparedGame.matchedAnswers.first == targetAnswerA)
        _ = preparedGame.matchAnswer(targetAnswerB)
        XCTAssert(preparedGame.matchedAnswers.first == targetAnswerB, "The top answer of the list should always be the last matched answer.")
    }
    
    func testMatchAnswer_failsWhenIsNotValid() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        let answerMatches = preparedGame.matchAnswer("definitely-not-a-valid-answer")
        
        XCTAssertFalse(answerMatches)
        XCTAssertFalse(gameDelegate.hasReceivedScoreUpdate, "The delegate is not warned if an answer matching fails.")
    }
    
    func testMatchAnswer_failsWhenAlreadyMatched() {
        let targetAnswer = preparedGame.quiz?.answer.first ?? ""
        preparedGame.startQuiz()
        
        _ = preparedGame.matchAnswer(targetAnswer)
        let answerMatchesTwice = preparedGame.matchAnswer(targetAnswer)
        
        XCTAssertFalse(answerMatchesTwice)
    }
    
    // MARK: Time Update Tests
    
    func testSetMatchDuration() {
        let previousDuration = preparedGame.matchDuration
        
        preparedGame.setQuizDuration(minutes: 0, seconds: Int(previousDuration) * 2)
        let durationChanged = !preparedGame.matchDuration.isEqual(to: previousDuration, upToDecimalDigits: 1)
        
        XCTAssert(durationChanged)
    }
    
    func testUpdate_NotifyAboutTimeRemaining() {
        preparedGame.startQuiz()
        gameDelegate.resetState()
        
        timeMachine.travel(by: 1)
        preparedGame.forceUpdate()
        
        XCTAssert(gameDelegate.hasReceivedTimeUpdate, "The delegate should be notified about the remaining time")
        XCTAssert(gameDelegate.notifiedTime < preparedGame.matchDuration)
    }
}
