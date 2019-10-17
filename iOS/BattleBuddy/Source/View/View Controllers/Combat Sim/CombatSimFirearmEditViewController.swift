//
//  CombatSimFirearmEditViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class CombatSimFirearmEditViewController: BaseTableViewController {
    var firearmSection = GroupedTableViewSection(headerTitle: "firearm".local())
    var firearmCell = BaseTableViewCell(text: "common_none".local())

    var ammoSection = GroupedTableViewSection(headerTitle: "ammunition".local())
    var sections: [GroupedTableViewSection]

    let firearm: SimulationFirearm?

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ firearm: SimulationFirearm?) {
        self.firearm = firearm
        self.firearmSection.cells = [firearmCell]
        self.sections = [firearmSection, ammoSection]

        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_firearm".local()

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func save() {
        
    }
}

extension CombatSimFirearmEditViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = sections[indexPath.section].cells[indexPath.row]
    }
}
