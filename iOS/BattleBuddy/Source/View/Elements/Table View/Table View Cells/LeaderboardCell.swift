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

    var rank: Int = 0 { didSet { updateLabels() } }
    var user: BBUser? {
        didSet {
            guard let user = user else { return }
            nameLabel.text = user.nickname ?? "nickname_anon".local()
            scoreLabel.text = scoreFormatter.string(from: user.loyalty)
        }
    }
    var isCurrentUser: Bool = false { didSet { updateLabels() } }

    let stackView = BaseStackView(axis: .horizontal, distribution: .fill, spacing: 2.0, xPaddingCompact: 15.0, xPaddingRegular: 15.0, yPadding: 4.0)
    let rankLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(white: 0.7, alpha: 1.0)
        return label
    }()
    let nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .white
        return label
    }()
    let scoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .invNatural
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

    func updateLabels() {
        rankLabel.text = NSNumber(value: rank).stringValue

        if isCurrentUser {
            rankLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
            nameLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)
            scoreLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .medium)

            rankLabel.textColor = UIColor.Theme.primary
            nameLabel.textColor = UIColor.Theme.primary
            scoreLabel.textColor = UIColor.Theme.primary
        } else {
            rankLabel.textColor = UIColor.init(white: 0.7, alpha: 1.0)
            nameLabel.textColor = .white
            scoreLabel.textColor = .white

            switch rank {
            case 1:
                rankLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .thin)
                nameLabel.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
                scoreLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
            case 2...3:
                rankLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .thin)
                nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
                scoreLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
            case 4...5:
                rankLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .thin)
                nameLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .medium)
                scoreLabel.font = UIFont.systemFont(ofSize: 19.0, weight: .regular)
            default:
                rankLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .thin)
                nameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .regular)
                scoreLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .regular)
            }
        }
    }
}
