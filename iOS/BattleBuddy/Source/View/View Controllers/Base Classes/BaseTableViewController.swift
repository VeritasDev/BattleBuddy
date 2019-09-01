//
//  BaseTableViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/24/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.Theme.background
        tableView.separatorColor = UIColor(white: 0.4, alpha: 1.0)
    }
}
