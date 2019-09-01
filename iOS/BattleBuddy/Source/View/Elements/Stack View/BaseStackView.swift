//
//  BaseStackView.swift
//  BattleBuddy
//
//  Created by Mike on 7/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseStackView: UIStackView {
    static let defaultSpacing: CGFloat = 10.0
    static let defaultPaddingCompact: CGFloat = 10.0
    static let defaultPaddingRegular: CGFloat = 10.0
    lazy var backgroundView: UIView = { return addBackgroundView() }()
    var totalPadding: CGFloat {
        get {
            let itemCount = arrangedSubviews.count
            let totalSpacing = spacing * CGFloat(itemCount - 1)
            let verticalPadding = layoutMargins.top + layoutMargins.bottom
            return totalSpacing + verticalPadding
        }
    }

    required init(coder: NSCoder) { fatalError("NIMP") }

    init(axis: NSLayoutConstraint.Axis = .vertical, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = defaultSpacing, xPaddingCompact: CGFloat = defaultPaddingCompact, xPaddingRegular: CGFloat = defaultPaddingRegular, yPadding: CGFloat = defaultPaddingCompact) {
        super.init(frame: .zero)

        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing

        let isCompact = isCompactWidth()
        layoutMargins = UIEdgeInsets(top: yPadding, left: isCompact ? xPaddingCompact : xPaddingRegular, bottom: yPadding, right: isCompact ? xPaddingCompact : xPaddingRegular)
        isLayoutMarginsRelativeArrangement = true

        backgroundColor = UIColor.Theme.background
    }
}
