//
//  LeaderboardCell.swift
//  BattleBuddy
//
//  Created by Veritas on 9/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class LeaderboardCell: BaseTableViewCell {
    static let leaderboardCellReuseId: String = "LeaderboardCell"
    let scoreFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = false
        formatter.usesGroupingSeparator = true
        return formatter
    }()

    var rank: Int = 0 {
        didSet {
            rankLabel.text = NSNumber(value: rank).stringValue
        }
    }
    var user: BBUser? {
        didSet {
            guard let user = user else { return }
            nameLabel.text = user.nickname
            scoreLabel.text = scoreFormatter.string(from: user.adsWatched)
        }
    }

    let stackView = BaseStackView(axis: .horizontal, distribution: .fill, spacing: 2.0, xPaddingCompact: 15.0, xPaddingRegular: 15.0, yPadding: 4.0)
    let rankLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .thin)
        label.textColor = UIColor.init(white: 0.7, alpha: 1.0)
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    let scoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .regular)
        label.textColor = .white
        return label
    }()

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: LeaderboardCell.leaderboardCellReuseId)

        selectionStyle = .none

        contentView.addSubview(stackView)

        stackView.pinToContainer()

        stackView.addArrangedSubview(rankLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(scoreLabel)

        rankLabel.constrainWidth(35.0)
    }
}
