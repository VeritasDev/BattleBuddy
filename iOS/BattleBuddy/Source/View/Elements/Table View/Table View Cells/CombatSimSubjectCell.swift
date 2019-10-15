//
//  CombatSimSubjectCell.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class CombatSimSubjectCell: BaseTableViewCell {
    var person: Person? {
        didSet {
            guard let person = person else { return }
            avatar.personType = person.type
            personTypeLabel.text = person.type.local()
            aimLabel.text = person.aim.local()
            ammoLabel.text = person.firearmConfig.ammoConfiguration.compactMap{$0.resolvedAmmoName}.joined(separator: ", ")
            aimLabel.text = person.aim.local()
        }
    }
    let containerStackView: BaseStackView = BaseStackView(axis: .vertical, spacing: 1.0)

    let headerStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let avatar = TestSubjectAvatar()
    let personTypeLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let aimStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let aimKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.text = "combat_sim_aim_setting".local()
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        return label
    }()
    let aimLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let ammoStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let ammoKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.text = "ammunition".local()
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        return label
    }()
    let ammoLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let armorStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let armorKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.text = "armor".local()
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        return label
    }()
    let armorLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let firearmStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let firearmKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
        label.text = "firearm".local()
        label.textColor = UIColor(white: 0.8, alpha: 1.0)
        return label
    }()
    let firearmLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
        label.text = "-"
        label.textColor = .white
        return label
    }()


    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: nil)

        contentView.addSubview(containerStackView)

        containerStackView.pinToContainer()
        containerStackView.addArrangedSubview(headerStackView)

        avatar.constrainSize(CGSize(width: 70.0, height: 70.0))
        headerStackView.addArrangedSubview(avatar)
        headerStackView.addArrangedSubview(personTypeLabel)

        containerStackView.addArrangedSubview(aimStackView)
        aimStackView.addArrangedSubview(aimKeyLabel)
        aimStackView.addArrangedSubview(aimLabel)

        containerStackView.addArrangedSubview(armorStackView)
        armorStackView.addArrangedSubview(armorKeyLabel)
        armorStackView.addArrangedSubview(armorLabel)

        containerStackView.addArrangedSubview(ammoStackView)
        ammoStackView.addArrangedSubview(ammoKeyLabel)
        ammoStackView.addArrangedSubview(ammoLabel)

        containerStackView.addArrangedSubview(firearmStackView)
        firearmStackView.addArrangedSubview(firearmKeyLabel)
        firearmStackView.addArrangedSubview(firearmLabel)
    }
}
