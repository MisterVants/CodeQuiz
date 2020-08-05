//
//  Hideable.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

protocol Hideable {
    func hide()
    func show()
}

extension Hideable where Self: UIActivityIndicatorView {
    
    func hide() {
        stopAnimating()
        isHidden = true
    }
    
    func show() {
        isHidden = false
        startAnimating()
    }
}

extension UIActivityIndicatorView: Hideable {}
