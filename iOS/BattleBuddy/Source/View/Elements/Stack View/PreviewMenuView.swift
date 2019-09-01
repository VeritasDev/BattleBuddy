//
//  PreviewMenuView.swift
//  BattleBuddy
//
//  Created by Mike on 7/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class PreviewMenuView: BaseStackView {
    let itemImageView = BaseImageView(imageSize: .medium)
    var contentContainerStackView = BaseStackView(spacing: 3.0, xPaddingCompact: 20.0, xPaddingRegular: 30.0, yPadding: 20.0)
    var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        label.layer.masksToBounds = false
        label.layer.shadowColor = UIColor.init(white: 0.1, alpha: 1.0).cgColor
        return label
    }()
    var subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .init(white: 8, alpha: 1.0)
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18.0, weight: .semibold)
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.masksToBounds = false
        label.layer.shadowColor = UIColor.init(white: 0.1, alpha: 1.0).cgColor
        return label
    }()
    var displayableItem: Displayable? {
        didSet {
            guard let item = displayableItem else { fatalError() }
            itemImageView.displayableItem = item
            headerLabel.text = item.shortTitle
            headerLabel.font = item.titleFont
            subtitleLabel.text = item.subtitle
        }
    }

    required init(coder aDecoder: NSCoder) { fatalError("NIMP") }

    init() {
        super.init(xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)

        addArrangedSubview(itemImageView)

        contentContainerStackView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.addSubview(contentContainerStackView)

        if displayableItem?.subtitle != nil {
            contentContainerStackView.addArrangedSubview(subtitleLabel)
        }

        contentContainerStackView.addArrangedSubview(headerLabel)
        contentContainerStackView.addArrangedSubview(UIView())

        contentContainerStackView.pinToContainer()
    }
}
