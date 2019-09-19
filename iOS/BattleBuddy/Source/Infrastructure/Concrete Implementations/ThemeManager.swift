//
//  ThemeManager.swift
//  BattleBuddy
//
//  Created by Mike on 6/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ThemeManager {
    class func configureAppearance() {
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.barStyle = .black
        navBarAppearance.tintColor = UIColor.Theme.primary
        navBarAppearance.isTranslucent = true
        let navBarItemAttr: [NSAttributedString.Key : Any]? = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = navBarItemAttr

        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.isTranslucent = true
        tabBarAppearance.barStyle = .black
        tabBarAppearance.tintColor = UIColor.Theme.primary
        tabBarAppearance.unselectedItemTintColor = .gray

        let switchAppearance = UISwitch.appearance()
        switchAppearance.onTintColor = UIColor.Theme.primary
    }
}
