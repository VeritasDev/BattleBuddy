//
//  CombatSimIndividualResultView.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

class CombatSimIndividualResultView: BaseStackView {
    var individualResult: CombatSimulationIndividualResult? {
        didSet {
            guard let individualResult = individualResult else { return }

            resultLabel.text = individualResult.result.local()

            switch individualResult.result {
            case .win: resultLabel.textColor = .green
            case .loss: resultLabel.textColor = .red
            case .tie: resultLabel.textColor = .white
            }

            winPercentLabel.text = String(individualResult.winPercent) + "%"
            timeToKillLabel.text = String(individualResult.avtTtk) + "seconds_abbr".local()
            shotsToKillLabel.text = String(individualResult.avgStk)

            subjectSummaryView.individualResult = individualResult
        }
    }

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

    init() {
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
    }
}
