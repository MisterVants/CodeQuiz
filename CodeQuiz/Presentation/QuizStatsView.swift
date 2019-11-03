//
//  QuizStatsView.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizStatsView: UIView {
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "00/00"
        label.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.font = UIFont.preferredFont(forTextStyle: .title1, weight: .bold)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let layoutGuide = UILayoutGuide()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.graySuperLight
        
        addLayoutGuide(layoutGuide)
        addSubview(scoreLabel)
        addSubview(timeLabel)
        addSubview(button)
        subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let guideConstraints = [
            layoutGuide.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.default),
            layoutGuide.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Spacing.default),
            layoutGuide.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Spacing.default),
            layoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Spacing.default)]
        
        let scoreConstraints = [
            scoreLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            scoreLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor)]
        
        let timeConstraints = [
            timeLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor)]
        
        let buttonConstraints = [
            button.heightAnchor.constraint(equalToConstant: 44),
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
