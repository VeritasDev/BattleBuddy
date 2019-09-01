//
//  SortableHeaderView.swift
//  BattleBuddy
//
//  Created by Mike on 7/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol SortableHeaderViewDelegate {
    func toggleSort(param: SortableParam)
}

class SortableHeaderView: UIView {
    let delegate: SortableHeaderViewDelegate
    let params: [SortableParam]
    let stackView = BaseStackView(axis: .horizontal, distribution: .fillEqually)
    lazy var buttons: [UIButton] = {
        var buttons: [UIButton] = []
        for param in params {
            let button = UIButton(type: .system)
            button.setTitle(param.local(short: false), for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .thin)
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.lineBreakMode = .byWordWrapping
            buttons.append(button)
        }
        return buttons
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(delegate: SortableHeaderViewDelegate, params: [SortableParam], initialSort: SortableParam) {
        self.delegate = delegate
        self.params = params

        super.init(frame: .zero)

        backgroundColor = UIColor.Theme.background.withAlphaComponent(0.8)

        addSubview(stackView)

        stackView.pinToContainer()

        let bottomDivider = UIView()
        bottomDivider.backgroundColor = UIColor(white: 0.15, alpha: 1.0)
        addSubview(bottomDivider)

        bottomDivider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomDivider.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomDivider.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomDivider.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomDivider.heightAnchor.constraint(equalToConstant: 1.0)
            ])

        let indexOfInitialSort = params.firstIndex { $0.identifier == initialSort.identifier }
        for index in 0..<buttons.count {
            let weight = (index == indexOfInitialSort) ? UIFont.Weight.bold : UIFont.Weight.thin
            let button = buttons[index]
            button.addTarget(self, action: #selector(handleSelection(sender:)), for: .touchUpInside)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: weight)
            stackView.addArrangedSubview(button)
        }
    }

    @objc func handleSelection(sender: UIButton) {
        let index = buttons.index(of: sender)!
        delegate.toggleSort(param: params[index])

        for button in buttons {
            let weight = (button == sender) ? UIFont.Weight.bold : UIFont.Weight.thin
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: weight)
        }
    }
}
