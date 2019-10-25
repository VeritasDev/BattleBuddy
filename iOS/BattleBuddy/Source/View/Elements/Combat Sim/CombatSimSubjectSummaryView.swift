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
            ammoLabel.text = character.ammo?.displayNameShort ?? none
            headArmorLabel.text = character.headArmor?.displayNameShort ?? none
            bodyArmorLabel.text = character.bodyArmor?.displayNameShort ?? none
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
    let headArmorKeyLabel = CombatSimResultKeyLabel(key: "combat_sim_head_armor".local())
    let headArmorLabel = CombatSimResultValueLabel()
    let bodyArmorKeyLabel = CombatSimResultKeyLabel(key: "body_armor".local())
    let bodyArmorLabel = CombatSimResultValueLabel()
    let aimKeyLabel = CombatSimResultKeyLabel(key: "combat_sim_aim_setting".local())
    let aimLabel = CombatSimResultValueLabel()

    required init(coder: NSCoder) { fatalError() }

    init() {
        super.init(axis: .vertical, alignment: .center)

        addArrangedSubview(avatar)
        addArrangedSubview(nameLabel)
        addArrangedSubview(aimKeyLabel)
        addArrangedSubview(aimLabel)
        addArrangedSubview(firearmKeyLabel)
        addArrangedSubview(firearmLabel)
        addArrangedSubview(ammoKeyLabel)
        addArrangedSubview(ammoLabel)
        addArrangedSubview(headArmorKeyLabel)
        addArrangedSubview(headArmorLabel)
        addArrangedSubview(bodyArmorKeyLabel)
        addArrangedSubview(bodyArmorLabel)

        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.constrainWidth(70.0)
        avatar.constrainHeight(70.0)
    }
}
