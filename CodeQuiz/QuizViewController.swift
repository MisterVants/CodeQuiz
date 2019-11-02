//
//  QuizViewController.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController {
    
    override func loadView() {
        self.view = QuizView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
