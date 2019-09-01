//
//  CompatibleModStatsCell.swift
//  BattleBuddy
//
//  Created by Mike on 7/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class CompatibleModStatsCell: UITableViewCell {
    static let reuseId = "CompatibleModStatsCell"
    var mod: ModdableMod? {
        didSet {
            guard let mod = mod else { fatalError() }
            nameLabel.text = mod.itemName
            recoilLabel.text = String(mod.recoil)
            ergoLabel.text = String(mod.ergo)
        }
    }
    lazy var stackView: UIStackView = {
        let stackView = BaseStackView(axis: .horizontal)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dividerView1)
        stackView.addArrangedSubview(ergoLabel)
        stackView.addArrangedSubview(dividerView2)
        stackView.addArrangedSubview(recoilLabel)
        stackView.addArrangedSubview(dividerView3)
        return stackView
    }()
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        return label
    }()
    let recoilLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .black)
        return label
    }()
    let ergoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .black)
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
    override var isSelected: Bool {
        didSet {
            nameLabel.textColor = isSelected ? UIColor.Theme.primary : .black
            recoilLabel.textColor = isSelected ? UIColor.Theme.primary : .black
            ergoLabel.textColor = isSelected ? UIColor.Theme.primary : .black
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: CompatibleModStatsCell.reuseId)

        contentView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            ])

        dividerView1.constrainWidth(1.0)
        ergoLabel.constrainWidth(50.0)
        dividerView2.constrainWidth(1.0)
        recoilLabel.constrainWidth(50.0)
        dividerView3.constrainWidth(1.0)
    }
}
