//
//  CombatSimViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class SimulationSubjectCell: BaseTableViewCell {
    init() {
        
    }
}

class CombatSimViewController: StaticGroupedTableViewController {
    let subject1Cell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_subject_1".local())
        return cell
    }()
    let subject2Cell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_subject_2".local())
        return cell
    }()
    let simulation = CombatSimulation()

    lazy var subject1EditViewController: CombatSimSubjectEditViewController = {
        return CombatSimSubjectEditViewController(self, person: simulation.subject1!)
    }()
    lazy var subject2EditViewController: CombatSimSubjectEditViewController = {
        return CombatSimSubjectEditViewController(self, person: simulation.subject2!)
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init() {
        super.init()

        simulation.subject1 = Person(aimSetting: .centerOfMass, firearm: nil)
        simulation.subject2 = Person(aimSetting: .centerOfMass, firearm: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "main_menu_combat_sim".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "combat_sim_run".local(), style: .plain, target: self, action: #selector(runSim))
    }

    override func generateSections() -> [GroupedTableViewSection] {
        let subjectSection = GroupedTableViewSection(headerTitle: "combat_sim_test_subjects".local(), cells: [subject1Cell, subject2Cell])
        let resultsSection = GroupedTableViewSection(headerTitle: "combat_sim_results".local(), cells: [])
        return [subjectSection, resultsSection]
    }

    @objc func runSim() {
        let firearm = FirearmConfig(fireRate: 200, ammoConfig: [])
        let subject1 = Person(aimSetting: .centerOfMass, firearm: firearm)
        simulation.runSimulation { (person1Result, person2Result) in

        }
    }

    override func handleCellSelected(_ cell: BaseTableViewCell) {
        switch cell {
        case subject1Cell: navigationController?.pushViewController(CombatSimSubjectEditViewController(self, person: simulation.subject1!), animated: true)
        case subject2Cell: navigationController?.pushViewController(CombatSimSubjectEditViewController(self, person: simulation.subject2!), animated: true)
        default: fatalError()
        }
    }
}

extension CombatSimViewController: SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing subject: Person) {
        switch subjectEditViewController {
        case subject1EditViewController: simulation.subject1 = subject
        case subject2EditViewController: simulation.subject2 = subject
        default: break
        }

        navigationController?.popViewController(animated: true)
    }
}
