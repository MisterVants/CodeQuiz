//
//  Reactive.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 03/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

struct Reactive<Value> {
    
    var value: Value {
        didSet {
            self.valueChanged?(self.value)
        }
    }
    
    private var valueChanged : ((Value)->())?
    
    init(_ value: Value) {
        self.value = value
    }
    
    mutating func update(_ value: Value) {
        self.value = value
    }
    
    mutating func bind(_ block: ((Value)->())?) {
        self.valueChanged = block
    }
    
    mutating func bindAndUpdate(_ block: ((Value)->())?) {
        self.valueChanged = block
        self.valueChanged?(value)
    }
    
    mutating func free() {
        self.valueChanged = nil
    }
}
