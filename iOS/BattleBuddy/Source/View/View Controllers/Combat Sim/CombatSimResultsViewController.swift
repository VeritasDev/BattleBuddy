//
//  CombatSimResultsViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class CombatSimResultsViewController: StaticGroupedTableViewController {
    let resultsSection: [GroupedTableViewSection]
    let resultsCell: CombatSimResultsCell

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(result: (CombatSimulationResultSummary, CombatSimulationResultSummary), subject1: Person, subject2: Person) {
        resultsCell = CombatSimResultsCell(result: result, subject1: subject1, subject2: subject2)
        resultsSection = [GroupedTableViewSection(headerTitle: nil, cells: [self.resultsCell])]

        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_results".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return resultsSection
    }

    @objc func handleDone() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
}
