//
//  LoadingView.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.graySuperDark
        view.layer.cornerRadius = 16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.color = .white
        return activityView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = Localized.loading
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        layoutView()
        activityView.show()
    }
    
    private func layoutView() {
        addSubview(contentView)
        contentView.addSubview(activityView)
        contentView.addSubview(label)
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let contentConstraints = [
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.2)
        ]
        
        let activityConstraints = [
            activityView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Spacing.large),
            activityView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        
        let labelConstraints = [
            label.topAnchor.constraint(equalTo: activityView.bottomAnchor, constant: Spacing.default),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Spacing.large),
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ]
        
        NSLayoutConstraint.activate([contentConstraints,
                                     activityConstraints,
                                     labelConstraints].flatMap {$0})
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension LoadingView: Hideable {
    
    func hide() {
        isHidden = true
        activityView.hide()
    }
    
    func show() {
        isHidden = false
        activityView.show()
    }
}
