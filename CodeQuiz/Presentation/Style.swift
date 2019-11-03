//
//  Style.swift
//  CodeQuiz
//
//  Created by André Vants Soares de Almeida on 02/11/19.
//  Copyright © 2019 André Vants. All rights reserved.
//

import UIKit

enum Spacing {
    
    /// Value: 16.0
    static let `default`: CGFloat = 16.0
    
    /// Value: 24.0
    static let large: CGFloat = 24.0
    
    /// Value: 44.0
    static let topPadding: CGFloat = 44.0
}

extension UIColor {
    
    /// HEX = `#FF8300` / RGB = 255, 131, 0
    static let orange = UIColor(literalRed: 255, green: 131, blue: 0)
    
    /// HEX = `#F5F5F5` / RGB = 245, 245, 245
    static let graySuperLight = UIColor(literalRed: 245, green: 245, blue: 245)
    
    /// HEX = `#191919` / RGB = 25, 25, 25
    static let graySuperDark = UIColor(literalRed: 25, green: 25, blue: 25)
    
    /// HEX = `#EBEBEB` / RGB = 235, 235, 235
    static let textFieldGray = UIColor(literalRed: 235, green: 235, blue: 235)
}

extension UIColor {

    convenience init(literalRed red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha))
    }
}
