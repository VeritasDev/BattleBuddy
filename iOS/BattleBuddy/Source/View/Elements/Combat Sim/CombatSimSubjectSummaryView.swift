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
    var individualResult: CombatSimulationIndividualResult? {
        didSet {
            guard let individualResult = individualResult else { return }
            avatar.result = individualResult.result
        }
    }
    var subject: Person? {
        didSet {
            guard let subject = subject else { return }

            let none = "common_none".local()
            avatar.personType = subject.type
            nameLabel.text = subject.type.local()
            firearmLabel.text = subject.firearmConfig.name
            ammoLabel.text = subject.firearmConfig.ammoConfiguration.isEmpty ? none : subject.firearmConfig.ammoConfiguration.compactMap{$0.resolvedAmmoName}.joined(separator: ", ")
            armorLabel.text = subject.equippedArmor.isEmpty ? none : subject.equippedArmor.compactMap{$0.resolvedArmorName}.joined(separator: ", ")
            aimLabel.text = subject.aim.local()
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
