//
//  BaseCardView.swift
//  BattleBuddy
//
//  Created by Mike on 7/9/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseCardView: UIView {
    private let baseCardViewXPadding: CGFloat = 20.0
    private let baseCardViewYPadding: CGFloat = 10.0

    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    let stackView = BaseStackView()

    required init(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: 4)

        addSubview(containerView)
        containerView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let containerSize = CGSize.init(width: frame.width - (2 * baseCardViewXPadding), height: frame.height - (2 * baseCardViewYPadding))
        containerView.frame = CGRect.init(x: baseCardViewXPadding, y: baseCardViewYPadding, width: containerSize.width, height: containerSize.height)

        layer.shadowRadius = containerView.frame.width * 0.03
    }

    func totalVerticalPadding() -> CGFloat {
        return (2 * baseCardViewYPadding) + (stackView.spacing * CGFloat(stackView.arrangedSubviews.count - 1)) + stackView.layoutMargins.top + stackView.layoutMargins.bottom
    }
}
