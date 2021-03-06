//
//  QuizViewController.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: Bindings
    
    var didLoadQuiz: ((_ question: String?) -> Void)?
    var reload: (() -> Void)?
    var insertIndexPaths: ((_ inserted: [IndexPath]) -> Void)?
    
    var scoreText = Reactive("00/00")
    var timestampText = Reactive("05:00")
    var actionText = Reactive(Localized.start)
    var isLoading = Reactive(false)
    
    // MARK: Lifecycle
    
    private let api = QuizAPI()
    private let game = QuizGame()
    
    override func loadView() {
        self.view = QuizView(controller: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        game.delegate = self
        game.setQuizDuration(minutes: 5, seconds: 0)
        setupGesture()
        loadQuiz()
    }
    
    // We hide the keyboard when transitioning to landscape to avoid unintentionally breaking constraints in the process.
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        if newCollection.verticalSizeClass == .compact {
            view.endEditing(true)
        }
    }
    
    // MARK: Control
    
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
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    // MARK: Private Methods
    
    // Setup a simple tap to hide keyboard. A scroll delegate on table view could be used to
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // Load the quiz from the API, then process the result in main thread to allow UI updates.
    private func loadQuiz() {
        isLoading.value = true
        api.getQuiz { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.processLoadResult(result)
            }
        }
    }
    
    private func processLoadResult(_ result: Result<Quiz, Error>) {
        do {
            let quiz = try result.get()
            game.prepareQuiz(quiz)
            didLoadQuiz?(game.quiz?.question)
        } catch {
            presentAlert(withTitle: Localized.Error.title, message: Localized.Error.message, actionName: Localized.Error.action) { _ in
                self.loadQuiz()
            }
        }
        isLoading.value = false
    }
    
    private func presentAlert(withTitle title: String, message: String, actionName: String, actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionName, style: .default, handler: actionHandler))
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
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.selectionStyle = .none
        cell.indentationLevel = 1
        return cell
    }
}

// MARK: Gesture Recognizer Delegate

extension QuizViewController: UIGestureRecognizerDelegate {
    
    // Allow any button presses to pass through the tap gesture and hit the button itself.
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view, touchedView.isKind(of: UIButton.self) {
            return false
        }
        return true
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
