//
//  BaseStackViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/26/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseStackViewController: BaseScrollViewController {
    let stackView: BaseStackView

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    init(_ stackView: BaseStackView = BaseStackView()) {
        self.stackView = stackView
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
    }
}
