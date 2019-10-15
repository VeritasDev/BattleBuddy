//
//  CombatSimResultView.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

class CombatSimResultView: BaseStackView {
    var subject: Person
    var result: CombatSimulationResultSummary

    let subjectSummaryView = CombatSimSubjectSummaryView()
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    let resultLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 26.0)
        return label
    }()
    let winPercentKeyLabel = CombatSimResultKeyLabel(key: "simulation_win_percent".local())
    let winPercentLabel = CombatSimResultValueLabel()
    let timeToKillKeyLabel = CombatSimResultKeyLabel(key: "simulation_time_to_kill".local())
    let timeToKillLabel = CombatSimResultValueLabel()
    let shotsToKillKeyLabel = CombatSimResultKeyLabel(key: "simulation_win_shots_to_kill".local())
    let shotsToKillLabel = CombatSimResultValueLabel()

    required init(coder: NSCoder) { fatalError() }

    init(_ result: CombatSimulationResultSummary, subject: Person, isSubject1: Bool) {
        self.result = result
        self.subject = subject

        super.init(axis: .vertical, alignment: .center)

        addArrangedSubview(subjectSummaryView)

        addArrangedSubview(separator)

        addArrangedSubview(resultLabel)
        addArrangedSubview(winPercentKeyLabel)
        addArrangedSubview(winPercentLabel)
        addArrangedSubview(timeToKillKeyLabel)
        addArrangedSubview(timeToKillLabel)
        addArrangedSubview(shotsToKillKeyLabel)
        addArrangedSubview(shotsToKillLabel)

        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1.0, constant: 0.0).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1.0).isActive = true

        resultLabel.text = result.result.local()

        switch result.result {
        case .win: resultLabel.textColor = .green
        case .loss: resultLabel.textColor = .red
        case .tie: resultLabel.textColor = .white
        }

        winPercentLabel.text = String(result.winPercent) + "%"
        timeToKillLabel.text = String(result.avtTtk) + "seconds_abbr".local()
        shotsToKillLabel.text = String(result.avgStk)

        subjectSummaryView.subject = subject
        subjectSummaryView.result = result
        subjectSummaryView.isSubject1 = isSubject1
    }
}

class CombatSimResultsCell: BaseTableViewCell {
    let resultsStackView: BaseStackView = BaseStackView(axis: .horizontal, alignment: .top, distribution: .fillEqually)
    let subject1View: CombatSimResultView
    let subject2View: CombatSimResultView

    required init?(coder: NSCoder) { fatalError() }

    init(result: (CombatSimulationResultSummary, CombatSimulationResultSummary), subject1: Person, subject2: Person) {
        self.subject1View = CombatSimResultView(result.0, subject: subject1, isSubject1: true)
        self.subject2View = CombatSimResultView(result.1, subject: subject2, isSubject1: false)

        super.init(style: .default, reuseIdentifier: nil)

        selectionStyle = .none
        isUserInteractionEnabled = false

        contentView.addSubview(resultsStackView)

        resultsStackView.pinToContainer()

        resultsStackView.addArrangedSubview(subject1View)
        resultsStackView.addArrangedSubview(subject2View)
    }
}
