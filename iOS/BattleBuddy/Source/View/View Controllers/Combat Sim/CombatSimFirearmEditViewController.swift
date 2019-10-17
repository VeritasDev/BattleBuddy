//
//  CombatSimFirearmEditViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class CombatSimFirearmEditViewController: BaseTableViewController {
    let firearmSection = GroupedTableViewSection(headerTitle: "firearm".local(), cells: [])
    let ammoSection = GroupedTableViewSection(headerTitle: "ammunition".local(), cells: [])

    init(_ firearm: Firearm, ammo: [Ammo])
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_firearm".local()
    }
}
