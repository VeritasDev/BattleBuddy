//
//  AmmoStatsCell.swift
//  BattleBuddy
//
//  Created by Mike on 7/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class AmmoStatsCell: UITableViewCell {
    static let reuseId = "AmmoStatsCell"
    var ammo: Ammo? {
        didSet {
            guard let ammo = ammo else { fatalError() }
            nameLabel.text = ammo.displayNameShort
            caliberLabel.text = ammo.caliber
            penLabel.text = String(ammo.penetration)
            damageLabel.text = String(ammo.damage)
        }
    }
    lazy var stackView: UIStackView = {
        let stackView = BaseStackView(axis: .horizontal)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dividerView1)
        stackView.addArrangedSubview(caliberLabel)
        stackView.addArrangedSubview(dividerView2)
        stackView.addArrangedSubview(penLabel)
        stackView.addArrangedSubview(dividerView3)
        stackView.addArrangedSubview(damageLabel)
        stackView.addArrangedSubview(dividerView4)
        return stackView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    let caliberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.numberOfLines = 2
        return label
    }()
    let damageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    let penLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    let armorDamageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        return label
    }()
    let dividerView1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    let dividerView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    let dividerView3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    let dividerView4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        return view
    }()
    override var isSelected: Bool {
        didSet {
            let color = isSelected ? UIColor.Theme.primary : .black
            nameLabel.textColor = color
            caliberLabel.textColor = color
            penLabel.textColor = color
            damageLabel.textColor = color
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: AmmoStatsCell.reuseId)

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])

        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2, constant: 1.0),
            dividerView1.widthAnchor.constraint(equalToConstant: 1.0),
            caliberLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2, constant: 1.0),
            dividerView2.widthAnchor.constraint(equalToConstant: 1.0),
            penLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2, constant: 1.0),
            dividerView3.widthAnchor.constraint(equalToConstant: 1.0),
            damageLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.2, constant: 1.0),
            dividerView4.widthAnchor.constraint(equalToConstant: 1.0)
            ])
    }
}
