//
//  QuizStatsView.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizStatsView: UIView {
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = Style.Corner.smallRadius
        return button
    }()
    
    private let layoutGuide = UILayoutGuide()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAppearance()
        layoutView()
    }
    
    private func setAppearance() {
        backgroundColor = UIColor.graySuperLight
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shadowOpacity = 1
    }
    
    private func layoutView() {
        addLayoutGuide(layoutGuide)
        addSubview(scoreLabel)
        addSubview(timeLabel)
        addSubview(button)
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let guideConstraints = [
            layoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.default),
            layoutGuide.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Spacing.default),
            layoutGuide.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Spacing.default),
            layoutGuide.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Spacing.default)]
        
        let scoreConstraints = [
            scoreLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor)]
        
        let timeConstraints = [
            timeLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)]
        
        let buttonConstraints = [
            button.heightAnchor.constraint(equalToConstant: Style.buttonHeight),
            button.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: Spacing.default),
            button.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)]
        
        NSLayoutConstraint.activate([guideConstraints,
                                     scoreConstraints,
                                     timeConstraints,
                                     buttonConstraints].flatMap {$0})
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
