//
//  BarGraphView.swift
//  BattleBuddy
//
//  Created by Mike on 7/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BarGraphView: UIView {
    public var widthMultiplier: CGFloat = 0.9
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.15, alpha: 0.6)
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        return view
    }()
    private let filledView = UIView()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .medium)
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .invNatural
        label.textColor = .white
        return label
    }()

    var filledColor: UIColor = UIColor.Theme.primary { didSet { filledView.backgroundColor = filledColor } }
    var progress: Float = 0.0 { didSet { setNeedsLayout() } }
    var name: String? { didSet { nameLabel.text = name } }
    var valueText: String? { didSet { valueLabel.text = valueText } }

    required init(coder: NSCoder) { fatalError() }

    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        filledView.backgroundColor = filledColor

        addSubview(containerView)
        containerView.addSubview(filledView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(valueLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let height: CGFloat = self.frame.height

        containerView.frame = CGRect(x: 0, y: 0, width: self.frame.width * widthMultiplier, height: height)
        filledView.frame = CGRect(x: 0, y: 0, width: containerView.frame.width * CGFloat(progress), height: containerView.frame.height)

        let pad: CGFloat = 10
        let totalWidth = containerView.frame.width - (4 * pad)
        if let name = name, !name.isEmpty {
            let halfWidth = totalWidth / 2.0
            nameLabel.frame = CGRect(x: pad, y: 0, width: halfWidth, height: containerView.frame.height)
            valueLabel.frame = CGRect(x: nameLabel.frame.maxX + pad, y: 0, width: halfWidth, height: containerView.frame.height)
            valueLabel.textAlignment = .invNatural
        } else {
            valueLabel.frame = containerView.frame
            valueLabel.textAlignment = .center
        }
    }

}
