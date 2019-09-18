//
//  ComparisonCell.swift
//  BattleBuddy
//
//  Created by Mike on 8/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ComparisonCell: BaseTableViewCell {
    private let progressView: BarGraphView = {
        let progressView = BarGraphView()
        return progressView
    }()

    required init(coder: NSCoder) { fatalError() }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundView = UIView()
        layer.backgroundColor = UIColor.clear.cgColor
        contentView.backgroundColor = .clear
        contentView.addSubview(progressView)

        progressView.pinToContainer()
    }

    func update(keyColor: UIColor, name: String, valueText: String, progressPercent: Float) {
        progressView.filledColor = keyColor
        progressView.name = name
        progressView.valueText = valueText
        progressView.progress = progressPercent
        setNeedsLayout()
        progressView.setNeedsLayout()
    }
}
