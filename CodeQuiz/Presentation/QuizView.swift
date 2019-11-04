//
//  QuizView.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizView: UIView {
    
    static let tableCellIdentifier = "quizCell"
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let inputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localized.placeholderText
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.textFieldGray
        textField.layer.cornerRadius = Style.Corner.smallRadius
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.textFieldInset, height: textField.bounds.height))
        textField.leftViewMode = .always
        textField.isHidden = true
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: QuizView.tableCellIdentifier)
        return tableView
    }()
    
    private let footerView = QuizStatsView()
    private let loadingView = LoadingView()
    
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    
    init(controller: QuizViewController) {
        super.init(frame: .zero)
        backgroundColor = .white
        bindController(controller)
        layoutView()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(_:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    private func bindController(_ controller: QuizViewController) {
        tableView.dataSource = controller
        inputField.addTarget(controller, action: #selector(controller.textFieldDidChange(_:)), for: .editingChanged)
        footerView.button.addTarget(controller, action: #selector(controller.didPressGameButton(_:)), for: .touchUpInside)
        
        controller.scoreText.bindAndUpdate { [weak self] in self?.footerView.scoreLabel.text = $0 }
        controller.timestampText.bindAndUpdate { [weak self] in self?.footerView.timeLabel.text = $0 }
        controller.actionText.bindAndUpdate { [weak self] in self?.footerView.button.setTitle($0, for: .normal) }
        controller.isLoading.bindAndUpdate { [weak self] loading in self?.loadingView.isHidden = loading ? false : true }
        
        controller.didLoadQuiz = { [unowned self] question in
            self.questionLabel.text = question
            self.inputField.isHidden = false
        }
        
        controller.reload = { [unowned self] in
            self.tableView.reloadData()
            self.inputField.text = nil
        }
        
        controller.insertIndexPaths = { [unowned self] indexPaths in
            self.tableView.insertRows(at: indexPaths, with: .right)
        }
    }
    
    private func layoutView() {
        addSubview(questionLabel)
        addSubview(inputField)
        addSubview(tableView)
        addSubview(footerView)
        addSubview(loadingView)
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let topConstraint = questionLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.topPadding)
        let questionConstraints = [
            topConstraint,
            questionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Spacing.default),
            questionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.default)]
        self.topConstraint = topConstraint
        
        let inputConstraints = [
            inputField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Spacing.default),
            inputField.leadingAnchor.constraint(equalTo: questionLabel.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: questionLabel.trailingAnchor),
            inputField.heightAnchor.constraint(equalToConstant: Style.textFieldHeight)]
        
        let tableConstraints = [
            tableView.topAnchor.constraint(equalTo: inputField.bottomAnchor, constant: Spacing.small),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)]
        
        let bottomConstraint = footerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        let footerConstraints = [
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomConstraint]
        self.bottomConstraint = bottomConstraint
        
        let loadingConstraints = [
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate([questionConstraints,
                                     inputConstraints,
                                     tableConstraints,
                                     footerConstraints,
                                     loadingConstraints].flatMap {$0})
    }
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        
        // Get all info we need from the keyboard.
        let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let isOpening = endFrameY < UIScreen.main.bounds.size.height
        
        let maxVisibleY = endFrameY - convert(frame.origin, to: nil).y
        let displaceDistance = isOpening ? bounds.height - maxVisibleY : 0
        
        UIView.animate(withDuration: animationDuration) {
            
            // Not only we keep footer at bottom, but also move the heading elements to allow for more useful space on smaller devices like iPhone SE.
            if UITraitCollection.current.verticalSizeClass == .compact {
                self.topConstraint?.constant = isOpening ? 0 : Spacing.topPadding
                self.bottomConstraint?.constant = 0
            } else {
                self.topConstraint?.constant = Spacing.topPadding
                self.bottomConstraint?.constant = -displaceDistance
            }
            self.layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
