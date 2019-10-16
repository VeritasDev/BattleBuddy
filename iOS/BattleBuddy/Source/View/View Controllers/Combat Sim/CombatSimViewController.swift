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
    let characters: [Character]
    lazy var simulation: CombatSimulation = {
        guard let defaultCharConfig = characters.first else { fatalError() }
        return CombatSimulation(subject1Config: defaultCharConfig, subject2Config: defaultCharConfig)
    }()
    lazy var resultsCell: CombatSimResultsCell = CombatSimResultsCell(simulation)
    lazy var resultsSection = GroupedTableViewSection(headerTitle: "combat_sim_tap_to_edit".local(), cells: [resultsCell])

    lazy var subject1EditViewController = CombatSimSubjectEditViewController(self, characters: characters, person: simulation.subject1)
    lazy var subject2EditViewController = CombatSimSubjectEditViewController(self, characters: characters, person: simulation.subject2)

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(characters: [Character]) {
        self.characters = characters

        super.init()

        resultsCell.subject1ResultView.subjectSummaryView.avatar.addTarget(self, action: #selector(editSubject1), for: .touchUpInside)
        resultsCell.subject2ResultView.subjectSummaryView.avatar.addTarget(self, action: #selector(editSubject2), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "main_menu_combat_sim".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "combat_sim_run".local(), style: .plain, target: self, action: #selector(runSim))
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [resultsSection]
    }

    @objc func runSim() {
        showLoading()

        simulation.runSimulation { result in
            self.hideLoading()

            self.resultsCell.result = result
            self.tableView.reloadData()
        }
    }

    @objc func editSubject1() {
        navigationController?.pushViewController(subject1EditViewController, animated: true)
    }

    @objc func editSubject2() {
        navigationController?.pushViewController(subject2EditViewController, animated: true)
    }
}

extension CombatSimViewController: SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing subject: Person) {
        switch subjectEditViewController {
        case subject1EditViewController:
            resultsCell.subject1ResultView.subjectSummaryView.subject = subject
            resultsCell.result = nil
            simulation.subject1 = subject
        case subject2EditViewController:
            resultsCell.subject2ResultView.subjectSummaryView.subject = subject
            resultsCell.result = nil
            simulation.subject2 = subject
        default: break
        }

        navigationController?.popViewController(animated: true)
    }
}
