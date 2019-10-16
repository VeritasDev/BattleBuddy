//
//  CombatSimResultsCell.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class CombatSimResultsCell: BaseTableViewCell {
    let resultsStackView: BaseStackView = BaseStackView(axis: .horizontal, alignment: .top, distribution: .fillEqually)
    let subject1ResultView = CombatSimIndividualResultView()
    let subject2ResultView = CombatSimIndividualResultView()

    var result: CombatSimulationResultSummary? {
        didSet {
            subject1ResultView.individualResult = result?.subject1Result
            subject2ResultView.individualResult = result?.subject2Result
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    init(_ simulation: CombatSimulation) {
        super.init(style: .default, reuseIdentifier: nil)

        selectionStyle = .none

        contentView.addSubview(resultsStackView)

        resultsStackView.pinToContainer()

        resultsStackView.addArrangedSubview(subject1ResultView)
        resultsStackView.addArrangedSubview(subject2ResultView)

        subject1ResultView.subjectSummaryView.subject = simulation.subject1
        subject2ResultView.subjectSummaryView.subject = simulation.subject2
    }
}
