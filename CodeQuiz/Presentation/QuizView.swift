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
    private let headerGuide = UILayoutGuide()
    
    init(controller: QuizViewController) {
        super.init(frame: .zero)
        backgroundColor = .white
        bindController(controller)
        layoutView()
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
        addLayoutGuide(headerGuide)
        addSubview(questionLabel)
        addSubview(inputField)
        addSubview(tableView)
        addSubview(footerView)
        addSubview(loadingView)
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let headerConstraints = [
            headerGuide.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.topPadding),
            headerGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.default),
            headerGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.default)]
        
        let questionConstraints = [
            questionLabel.topAnchor.constraint(equalTo: headerGuide.topAnchor),
            questionLabel.leadingAnchor.constraint(equalTo: headerGuide.leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: headerGuide.trailingAnchor)]
        
        let inputConstraints = [
            inputField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: Spacing.default),
            inputField.leadingAnchor.constraint(equalTo: headerGuide.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: headerGuide.trailingAnchor),
            inputField.bottomAnchor.constraint(equalTo: headerGuide.bottomAnchor),
            inputField.heightAnchor.constraint(equalToConstant: Style.textFieldHeight)]
        
        let tableConstraints = [
            tableView.topAnchor.constraint(equalTo: headerGuide.bottomAnchor, constant: Spacing.small),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        let footerConstraints = [
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        let loadingConstraints = [
            loadingView.topAnchor.constraint(equalTo: topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate([headerConstraints,
                                     questionConstraints,
                                     inputConstraints,
                                     tableConstraints,
                                     footerConstraints,
                                     loadingConstraints].flatMap {$0})
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
