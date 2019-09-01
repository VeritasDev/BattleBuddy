//
//  BaseScrollViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/27/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseScrollViewController: BaseViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.Theme.background
        return scrollView
    }()

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init() {
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.Theme.background
        view.addSubview(scrollView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])

    }
}
