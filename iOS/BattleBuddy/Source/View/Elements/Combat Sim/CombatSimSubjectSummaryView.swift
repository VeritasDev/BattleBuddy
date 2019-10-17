//
//  CombatSimSubjectSummaryView.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

class CombatSimSubjectSummaryView: BaseStackView {
    var individualResult: CombatSimulationIndividualResult? { didSet { avatar.result = individualResult?.result } }
    var character: SimulationCharacter? {
        didSet {
            guard let character = character else { return }

            let none = "common_none".local()
            avatar.characterId = character.id
            nameLabel.text = character.name
            firearmLabel.text = character.firearm?.displayNameShort ?? none
            ammoLabel.text = character.ammoSummary()
            armorLabel.text = character.armorSummary()
            aimLabel.text = character.aim.local()
        }
    }
    let avatar: TestSubjectAvatar = TestSubjectAvatar()
    let nameLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.textColor = .white
        return label
    }()

    let firearmKeyLabel = CombatSimResultKeyLabel(key: "firearm".local())
    let firearmLabel = CombatSimResultValueLabel()

    let ammoKeyLabel = CombatSimResultKeyLabel(key: "ammunition".local())
    let ammoLabel = CombatSimResultValueLabel()

    let armorKeyLabel = CombatSimResultKeyLabel(key: "armor".local())
    let armorLabel = CombatSimResultValueLabel()

    let aimKeyLabel = CombatSimResultKeyLabel(key: "combat_sim_aim_setting".local())
    let aimLabel = CombatSimResultValueLabel()

    required init(coder: NSCoder) { fatalError() }

    init() {
        super.init(axis: .vertical, alignment: .center)

        addArrangedSubview(avatar)
        addArrangedSubview(nameLabel)

        addArrangedSubview(firearmKeyLabel)
        addArrangedSubview(firearmLabel)

        addArrangedSubview(ammoKeyLabel)
        addArrangedSubview(ammoLabel)

        addArrangedSubview(armorKeyLabel)
        addArrangedSubview(armorLabel)

        addArrangedSubview(aimKeyLabel)
        addArrangedSubview(aimLabel)

        avatar.constrainWidth(70.0)
        avatar.constrainHeight(70.0)
    }
}
