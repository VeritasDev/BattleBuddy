//
//  Theme.swift
//  BattleBuddy
//
//  Created by Mike on 7/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

extension UIColor {
    class func create(_ themeName: String) -> UIColor {
        return UIColor.init(named: themeName)!
    }

    struct Theme {
        static let primary: UIColor = .create("primaryThemeColor")
        static let background: UIColor = .create("backgroundTheme")
        static let lightGreen: UIColor = .create("lightGreen")
        static let darkGreen: UIColor = .create("darkGreen")
        static let orange: UIColor = .create("orange")
        static let yellow: UIColor = .create("yellow")
        static let rose: UIColor = .create("rose")
        static let grey: UIColor = .create("grey")
        static let lightBlue: UIColor = .create("lightBlue")
        static let darkBlue: UIColor = .create("darkBlue")
    }

    class func scaledGradientColor(percent: Float) -> UIColor {
        let r = CGFloat(scaleBetween(unscaledNum: percent, minAllowed: 0.5, maxAllowed: 1.0, min: 0.5, max: 1.0))
        return UIColor.init(red: r, green: 0.23, blue: 0.3, alpha: 1.0)
    }
}
