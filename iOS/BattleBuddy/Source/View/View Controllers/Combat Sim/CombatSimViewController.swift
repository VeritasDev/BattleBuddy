//
//  CombatSimViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class CombatSimViewController: BaseTableViewController {
    let subject1Cell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_subject_1".local())
        return cell
    }()
    let subject2Cell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_subject_2".local())
        return cell
    }()
    let penetrationCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_pen_setting".local())
        return cell
    }()
    let fragmentationCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_frag_setting".local())
        return cell
    }()
    var sections: [GroupedTableViewSection] = []
    let simulation = CombatSimulation()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "main_menu_combat_sim".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "combat_sim_run".local(), style: .plain, target: self, action: #selector(runSim))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateCells()
    }

    func updateCells() {
        let subjectSection = GroupedTableViewSection(headerTitle: "combat_sim_test_subjects".local(), cells: [subject1Cell, subject2Cell])
        let simSettingsSection = GroupedTableViewSection(headerTitle: "combat_sim_settings".local(), cells: [penetrationCell, fragmentationCell])
        let resultsSection = GroupedTableViewSection(headerTitle: "combat_sim_results".local(), cells: [])

        sections = [subjectSection, simSettingsSection, resultsSection]

        tableView.reloadData()
    }

    @objc func runSim() {
        let firearm = FirearmConfig(fireRate: 200, ammoConfig: [])
        let subject1 = Person(aimSetting: .centerOfMass, firearm: firearm)
        simulation.runSimulation { (person1Result, person2Result) in

        }
    }
}

// MARK: - Table view
extension CombatSimViewController {
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

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case subject1Cell: break
        case subject2Cell: break
        case penetrationCell: break
        case fragmentationCell: break
        default: fatalError()
        }
    }
}
