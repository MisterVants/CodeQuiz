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
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private let inputField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localized.placeholderText
        textField.borderStyle = .none
        textField.backgroundColor = UIColor.textFieldGray
        textField.layer.cornerRadius = 8
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.bounds.height))
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
    
    private let headerGuide = UILayoutGuide()
    
    init(controller: QuizViewController) {
        super.init(frame: .zero)
        
        tableView.dataSource = controller
        inputField.addTarget(controller, action: #selector(controller.textFieldDidChange(_:)), for: .editingChanged)
        footerView.button.addTarget(controller, action: #selector(controller.didPressGameButton(_:)), for: .touchUpInside)
        
        controller.scoreText.bindAndUpdate { [unowned self] in
            self.footerView.scoreLabel.text = $0
        }
//
        controller.timestampText.bindAndUpdate { [unowned self] in
            self.footerView.timeLabel.text = $0
        }
        
        controller.actionText.bindAndUpdate { [unowned self] in
            self.footerView.button.setTitle($0, for: .normal)
        }
        
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
        
        backgroundColor = .white
        layoutView()
    }
    
    private func layoutView() {
        addLayoutGuide(headerGuide)
        addSubview(questionLabel)
        addSubview(inputField)
        addSubview(tableView)
        addSubview(footerView)
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
            inputField.heightAnchor.constraint(equalToConstant: 50)]
        
        let tableConstraints = [
            tableView.topAnchor.constraint(equalTo: headerGuide.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let footerConstraints = [
            footerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate([headerConstraints,
                                     questionConstraints,
                                     inputConstraints,
                                     tableConstraints,
                                     footerConstraints].flatMap {$0})
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UIFont {
    
    class func preferredFont(forTextStyle textStyle: UIFont.TextStyle, weight: UIFont.Weight) -> UIFont {
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
        return UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
    }
}
