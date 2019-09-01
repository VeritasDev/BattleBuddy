//
//  BaseNavigationController.swift
//  BattleBuddy
//
//  Created by Mike on 6/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)

        navigationBar.prefersLargeTitles = true
        navigationBar.setBackgroundImage(nil, for: .default)
        navigationBar.shadowImage = UIImage()
        navigationItem.largeTitleDisplayMode = .always
    }
}
