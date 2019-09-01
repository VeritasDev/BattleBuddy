//
//  BaseViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {
    let hud = JGProgressHUD(style: .dark)
    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Theme.background
    }

    func showLoading() {
        hud.show(in: self.view)
    }

    func hideLoading() {
        hud.dismiss(animated: false)
    }
}

extension UIViewController {
    func presentDefaultAlert(title: String, message: String) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "ok".local(), style: .default))
        present(controller, animated: true)
    }
}
