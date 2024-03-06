//
//  UIResponder+Extension.swift
//  Tip_Calculator
//
//  Created by Fatih Emre Sarman on 6.03.2024.
//

import UIKit

extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}
