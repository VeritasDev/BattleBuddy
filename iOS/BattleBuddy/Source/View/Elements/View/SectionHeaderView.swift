//
//  SectionHeaderView.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SectionHeaderView: BaseStackView {
    private let yPadding: CGFloat = 2.0
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .black)
        label.textColor = .white
        return label
    }()

    required init(coder: NSCoder) { fatalError("NIMP") }

    init(headerText: String) {
        super.init(axis: .horizontal, xPaddingCompact: 15, yPadding: yPadding)

        label.text = headerText

        addArrangedSubview(label)
    }

    func height() -> CGFloat {
        label.sizeToFit()
        return label.frame.height + (2 * yPadding)
    }
}
