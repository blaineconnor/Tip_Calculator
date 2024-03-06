//
//  UIVire+Extension.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 5.03.2024.
//

import UIKit

extension UIView {
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
    
    func addCornerRadius(radius: CGFloat) {
        layer.masksToBounds = false
        layer.cornerRadius = radius
    }
    
    func addRounderCorners(corners: CACornerMask, radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [corners]
    }
}
