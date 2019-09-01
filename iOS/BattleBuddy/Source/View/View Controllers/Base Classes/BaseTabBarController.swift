//
//  BaseTabBarController.swift
//  BattleBuddy
//
//  Created by Mike on 6/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {
    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    init() {
        super.init(nibName: nil, bundle: nil)
    }
}
