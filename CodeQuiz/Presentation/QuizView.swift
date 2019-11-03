//
//  QuizView.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizView: UIView {
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle, weight: .bold)
        label.numberOfLines = 2
        label.text = "What are all the java keywords?"
        return label
    }()
    
    private let inputField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .lightGray
        textField.borderStyle = .roundedRect
        textField.placeholder = "Insert Word"
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let footerView = QuizStatsView()
    
    private let headerGuide = UILayoutGuide()
    
    init() {
        super.init(frame: .zero)
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
            inputField.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 8),
            inputField.leadingAnchor.constraint(equalTo: headerGuide.leadingAnchor),
            inputField.trailingAnchor.constraint(equalTo: headerGuide.trailingAnchor),
            inputField.bottomAnchor.constraint(equalTo: headerGuide.bottomAnchor),
            inputField.heightAnchor.constraint(equalToConstant: 40)]
        
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
