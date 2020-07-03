//
//  PriceCheckCell.swift
//  BattleBuddy
//
//  Created by Veritas on 7/1/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit

class PriceCheckCell: BaseTableViewCell {
    public static let ReuseIdentifier = "PriceCheckCell"
    let containerStackView = BaseStackView(axis: .horizontal, distribution: .fillEqually, spacing: 2.0, xPaddingCompact: 4.0, xPaddingRegular: 4.0)
    let trendingStackView = BaseStackView(axis: .horizontal, spacing: 0.0, xPaddingCompact: 4.0, xPaddingRegular: 4.0, yPadding: 2.0)
    let priceStackView = BaseStackView(axis: .vertical, spacing: 0.0, xPaddingCompact: 4.0, xPaddingRegular: 4.0)
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .light)
        label.textAlignment = .natural
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .invNatural
        return label
    }()
    let pricePerSlotLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        label.textColor = UIColor.lightGray
        label.textAlignment = .invNatural
        return label
    }()
    let trendingPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 13.0)
        label.textAlignment = .invNatural
        return label
    }()
    let trendingImageView = UIImageView()

    var marketItem: MarketItem? {
        didSet {
            guard let marketItem = marketItem else { return }
            nameLabel.text = marketItem.name
            priceLabel.text = marketItem.avgPrice24.roublesString()
            pricePerSlotLabel.text =  marketItem.slots > 1 ? "\(marketItem.pricePerSlot.roublesString()) / slot" : nil
            trendingPriceLabel.text = marketItem.diff24h.percentString()

            if (marketItem.diff24h > 0) {
                trendingPriceLabel.textColor = UIColor.green
                trendingImageView.tintColor = UIColor.green
                trendingImageView.image = UIImage(named: "trending_up")?.withRenderingMode(.alwaysTemplate)
            } else {
                trendingPriceLabel.textColor = UIColor.red
                trendingImageView.tintColor = UIColor.red
                trendingImageView.image = UIImage(named: "trending_down")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }

    required init?(coder: NSCoder) { fatalError() }
    
    init() {
        super.init(style: .default, reuseIdentifier: Self.ReuseIdentifier)

        contentView.addSubview(containerStackView)

        containerStackView.addArrangedSubview(nameLabel)
        containerStackView.addArrangedSubview(priceStackView)

        trendingStackView.addArrangedSubview(trendingPriceLabel)
        trendingStackView.addArrangedSubview(trendingImageView)

        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(pricePerSlotLabel)
        priceStackView.addArrangedSubview(trendingStackView)

        containerStackView.pinToContainer(xInset: 12.0, yInset: 1.0)
        trendingImageView.constrainSize(CGSize(width: 22.0, height: 22.0))
    }
}
