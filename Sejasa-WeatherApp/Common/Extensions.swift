//
//  Extensions.swift
//  Sejasa-WeatherApp
//
//  Created by Derrin on 09/08/22.
//

import UIKit

extension UIView {
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if self.responds(to: #selector(getter: safeAreaLayoutGuide)) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        else {
            return self.topAnchor
        }
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if self.responds(to: #selector(getter: safeAreaLayoutGuide)) {
            return self.safeAreaLayoutGuide.leadingAnchor
        }
        else {
            return self.leadingAnchor
        }
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if self.responds(to: #selector(getter: safeAreaLayoutGuide)) {
            return self.safeAreaLayoutGuide.trailingAnchor
        }
        else {
            return self.trailingAnchor
        }
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if self.responds(to: #selector(getter: safeAreaLayoutGuide)) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        else {
            return self.bottomAnchor
        }
    }
    
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}

extension NSLayoutConstraint {
    func withPriority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}

extension UIColor {
    static let brightYellow: UIColor = UIColor(red: 242.0 / 255.0, green: 250.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    static let darkRedSky: UIColor = UIColor(red: 178.0 / 255.0, green: 58.0 / 255.0, blue: 123.0 / 255.0, alpha: 1.0)
    static let orangeSky: UIColor = UIColor(red: 254.0 / 255.0, green: 150.0 / 255.0, blue: 122.0 / 255.0, alpha: 1.0)
    static let skyBlue: UIColor = UIColor(red: 60.0 / 255.0, green: 197.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
    static let skyLightBlue: UIColor = UIColor(red: 175.0 / 255.0, green: 227.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
}
