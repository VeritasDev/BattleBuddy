//
//  BarGraphView.swift
//  BattleBuddy
//
//  Created by Mike on 7/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    private let filledView: BaseStackView = {
        let view = BaseStackView(axis: .horizontal, distribution: .fillEqually, xPaddingCompact: 10.0, xPaddingRegular: 10.0, yPadding: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()
    private lazy var filledWidthConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: filledView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
    }()

    var filledColor: UIColor = UIColor.Theme.primary { didSet { filledView.backgroundView.backgroundColor = filledColor } }

    var progress: Float = 0.0 {
        didSet {
            filledWidthConstraint = filledWidthConstraint.deactivateAndCreateNewActivated(multiplier: CGFloat(progress))
            layoutIfNeeded()
        }
    }

    var name: String? {
        didSet {
            nameLabel.text = name
        }
    }

    var valueText: String? {
        didSet {
            valueLabel.text = valueText
        }
    }

    required init(coder: NSCoder) { fatalError() }

    init() {
        super.init(frame: .zero)

        backgroundColor = .clear

        addSubview(filledView)

        NSLayoutConstraint.activate([
            filledView.topAnchor.constraint(equalTo: topAnchor),
            filledView.bottomAnchor.constraint(equalTo: bottomAnchor),
            filledView.leadingAnchor.constraint(equalTo: leadingAnchor)
            ])

        filledView.addArrangedSubview(nameLabel)
        filledView.addArrangedSubview(valueLabel)
    }

}
