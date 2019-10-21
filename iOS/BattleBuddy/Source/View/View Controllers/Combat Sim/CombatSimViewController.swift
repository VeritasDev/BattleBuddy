//
//  CombatSimViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

struct CombatSimPlayerConfiguration {
    var character: Character
    var aim: AimSetting
    var firearm: Firearm
    var ammoSelections: [Ammo]
    var helmet: Armor
    var armor: Armor
}

class CombatSimViewController: StaticGroupedTableViewController {
    let characters: [Character]
    var simCharacter1: SimulationCharacter
    var simCharacter2: SimulationCharacter
    let simulation: CombatSimulation

    lazy var resultsCell: CombatSimResultsCell = CombatSimResultsCell(simulation, char1: simCharacter1, char2: simCharacter2)
    lazy var resultsSection = GroupedTableViewSection(headerTitle: "combat_sim_tap_to_edit".local(), cells: [resultsCell])

    lazy var subject1EditViewController = CombatSimSubjectEditViewController(self, characters: characters, character: simCharacter1)
    lazy var subject2EditViewController = CombatSimSubjectEditViewController(self, characters: characters, character: simCharacter2)

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(characters: [Character]) {
        guard let defaultChar = characters.first,
            let char1 = SimulationCharacter(json: defaultChar.json),
            let char2 = SimulationCharacter(json: defaultChar.json) else { fatalError() }

        self.characters = characters
        self.simCharacter1 = char1
        self.simCharacter2 = char2
        self.simulation = CombatSimulation(subject1Config: char1, subject2Config: char2)

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
        let nc = BaseNavigationController(rootViewController: subject1EditViewController)
        navigationController?.present(nc, animated: true, completion: nil)
    }

    @objc func editSubject2() {
        let nc = BaseNavigationController(rootViewController: subject2EditViewController)
        navigationController?.present(nc, animated: true, completion: nil)
    }
}

extension CombatSimViewController: SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewControllerDidCancel(_ subjectEditViewController: CombatSimSubjectEditViewController) {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing character: SimulationCharacter) {
        switch subjectEditViewController {
        case subject1EditViewController:
            simCharacter1 = character
            resultsCell.subject1ResultView.subjectSummaryView.character = character
            resultsCell.result = nil
            simulation.subject1 = Person(character)
        case subject2EditViewController:
            simCharacter2 = character
            resultsCell.subject2ResultView.subjectSummaryView.character = character
            resultsCell.result = nil
            simulation.subject2 = Person(character)
        default: break
        }

        navigationController?.dismiss(animated: true, completion: nil)
    }
}
