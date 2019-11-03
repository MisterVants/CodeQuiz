//
//  QuizViewController.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    var didLoadQuiz: ((_ question: String?) -> Void)?
    var reload: (() -> Void)?
    var insertIndexPaths: ((_ inserted: [IndexPath]) -> Void)?
    
    var scoreText = Reactive("00/00")
    var timestampText = Reactive("00:00")
    var actionText = Reactive(Localized.start)
    
    private let api = QuizAPI()
    private let game = QuizGame()
    
    override func loadView() {
        self.view = QuizView(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
//        game.setQuizDuration(minutes: 5, seconds: 0)
        game.setQuizDuration(minutes: 0, seconds: 5)
        loadQuiz()
    }
    
    @objc func didPressGameButton(_ button: UIButton) {
        game.startQuiz(forcingRestart: true)
        reload?()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let possibleAnswer = textField.text ?? ""
        if game.matchAnswer(possibleAnswer) {
            textField.text = nil
        }
    }
    
    private func loadQuiz() {
        api.getQuiz { result in
            do {
                let quiz = try result.get()
                self.game.prepareQuiz(quiz)
                DispatchQueue.main.async { self.didLoadQuiz?(self.game.quiz?.question) }
            } catch {
                // error
            }
        }
    }
    
    private func presentAlert(withTitle title: String, message: String, actionName: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionName, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: Table View Data Source

extension QuizViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return game.matchedAnswers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: QuizView.tableCellIdentifier, for: indexPath)
        cell.textLabel?.text = game.matchedAnswers[indexPath.row]
        cell.selectionStyle = .none
        cell.indentationLevel = 1
        return cell
    }
}

// MARK: Quiz Game Delegate

extension QuizViewController: QuizGameDelegate {
    
    func quizGame(_ game: QuizGame, shouldUpdateRemainingTime remainingTime: TimeInterval) {
        timestampText.value = TimeFormatter.timestamp(from: remainingTime)
    }
    
    func quizGame(_ game: QuizGame, shouldUpdateScore newScore: Int) {
        let currentText = String(format: "%02d", newScore)
        let totalText = String(format: "%02d", game.targetScore)
        scoreText.value = currentText.appending("/").appending(totalText)
    }
    
    func quizGame(_ game: QuizGame, didInsertAnswerAt index: Int) {
        let insertIndex = IndexPath(row: index, section: 0)
        insertIndexPaths?([insertIndex])
    }
    
    func quizGame(_ game: QuizGame, didChangeState newState: QuizGame.State) {
        switch newState {
        case .idle:
            actionText.value = Localized.start
        case .playing:
            actionText.value = Localized.reset
        }
    }
    
    func quizGame(_ game: QuizGame, didFinishWithResult finishResult: QuizGame.FinishResult) {
        switch finishResult {
        case .victory:
            presentAlert(withTitle: Localized.Quiz.Success.title,
                         message: Localized.Quiz.Success.message,
                         actionName: Localized.Quiz.Success.action)
        case .defeat:
            presentAlert(withTitle: Localized.Quiz.Failure.title,
                         message: Localized.Quiz.Failure.message("\(game.currentScore)", "\(game.targetScore)"),
                         actionName: Localized.Quiz.Failure.action)
        }
    }
}
