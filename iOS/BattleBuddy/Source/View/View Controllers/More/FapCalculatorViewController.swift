//
//  FapCalculatorViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/3/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class FapCalculatorViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "fap_calc_title".local()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
}
