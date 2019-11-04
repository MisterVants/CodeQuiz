//
//  QuizStatsView.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizStatsView: UIView {
    
    /// A label to displays a score in the format `00/00`
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    /// A label to displays a timestamp in the format `00:00`
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1).bold()
        return label
    }()
    
    /// The button used to start and reset the quiz.
    let gameButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = Style.Corner.smallRadius
        return button
    }()
    
    private let layoutGuide = UILayoutGuide()
    private var buttonTop: NSLayoutConstraint?
    private var buttonHeight: NSLayoutConstraint?
    private var closerBottom: NSLayoutConstraint?
    
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
        addSubview(gameButton)
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
        
        let buttonHeight = gameButton.heightAnchor.constraint(equalToConstant: Style.buttonHeight)
        let buttonTop = gameButton.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: Spacing.default)
        let closerBottom = scoreLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)
        
        let buttonConstraints = [
            buttonHeight,
            buttonTop,
            gameButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            gameButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            gameButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor)]
        
        self.buttonTop = buttonTop
        self.buttonHeight = buttonHeight
        self.closerBottom = closerBottom
        
        NSLayoutConstraint.activate([guideConstraints,
                                     scoreConstraints,
                                     timeConstraints,
                                     buttonConstraints].flatMap {$0})
    }
    
    // The stats view takes too much space in landscape mode, so we hide the button to improve the content navigation.
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if UITraitCollection.current.verticalSizeClass == .compact {
            buttonHeight?.constant = 0
            buttonTop?.isActive = false
            closerBottom?.isActive = true
        } else {
            buttonHeight?.constant = Style.buttonHeight
            closerBottom?.isActive = false
            buttonTop?.isActive = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
