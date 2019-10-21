//
//  SectionHeaderView.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SectionHeaderView: BaseStackView {
    var actionHandler: (() -> Void)?
    private let yPadding: CGFloat = 2.0
    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .black)
        label.textColor = .white
        return label
    }()
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.Theme.primary, for: .normal)
        return button
    }()

    required init(coder: NSCoder) { fatalError("NIMP") }

    init(headerText: String) {
        super.init(axis: .horizontal, xPaddingCompact: 15, yPadding: yPadding)

        label.text = headerText

        addArrangedSubview(label)
    }

    convenience init(headerText: String, actionText: String, actionHandler: @escaping () -> Void) {
        self.init(headerText: headerText)

        self.actionHandler = actionHandler

        actionButton.setTitle(actionText, for: .normal)
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        addArrangedSubview(actionButton)
    }

    func height() -> CGFloat {
        label.sizeToFit()
        return label.frame.height + (2 * yPadding)
    }

    @objc func handleAction() {
        guard let handler = actionHandler else { fatalError() }
        handler()
    }
}
