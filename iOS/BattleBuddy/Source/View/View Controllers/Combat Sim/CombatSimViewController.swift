//
//  CombatSimViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class CombatSimViewController: StaticGroupedTableViewController {
    let subject1Cell: CombatSimSubjectCell = CombatSimSubjectCell()
    let subject2Cell: CombatSimSubjectCell = CombatSimSubjectCell()
    var subject1Section = GroupedTableViewSection(headerTitle: "combat_sim_subject_1".local(), cells: [])
    var subject2Section = GroupedTableViewSection(headerTitle: "combat_sim_subject_2".local(), cells: [])
    let simulation = CombatSimulation()

    lazy var subject1EditViewController: CombatSimSubjectEditViewController = {
        return CombatSimSubjectEditViewController(self, person: simulation.subject1)
    }()
    lazy var subject2EditViewController: CombatSimSubjectEditViewController = {
        return CombatSimSubjectEditViewController(self, person: simulation.subject2)
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init() {
        super.init()

        subject1Cell.person = simulation.subject1
        subject2Cell.person = simulation.subject2

        subject1Section.cells = [subject1Cell]
        subject2Section.cells = [subject2Cell]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "main_menu_combat_sim".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "combat_sim_run".local(), style: .plain, target: self, action: #selector(runSim))
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [subject1Section, subject2Section]
    }

    @objc func runSim() {
        showLoading()

        simulation.runSimulation { (person1Result, person2Result) in
            self.hideLoading()

            let resultsNC = BaseNavigationController(rootViewController: CombatSimResultsViewController(result: (person1Result, person2Result), subject1: self.simulation.subject1, subject2: self.simulation.subject2))
            self.navigationController?.present(resultsNC, animated: true, completion: nil)
        }
    }

    override func handleCellSelected(_ cell: BaseTableViewCell) {
        switch cell {
        case subject1Cell: navigationController?.pushViewController(subject1EditViewController, animated: true)
        case subject2Cell: navigationController?.pushViewController(subject2EditViewController, animated: true)
        default: fatalError()
        }
    }
}

extension CombatSimViewController: SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing subject: Person) {
        switch subjectEditViewController {
        case subject1EditViewController:
            subject1Cell.person = subject
            simulation.subject1 = subject
        case subject2EditViewController:
            subject2Cell.person = subject
            simulation.subject2 = subject
        default: break
        }

        navigationController?.popViewController(animated: true)
    }
}
