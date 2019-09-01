//
//  PostViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = UIColor.Theme.background
        return scrollView
    }()
    let stackView: BaseStackView
    let config: PostConfiguration

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ postConfig: PostConfiguration) {
        self.stackView = BaseStackView(spacing: 5.0, xPaddingCompact: 0.0, xPaddingRegular: 50.0, yPadding: 0.0)
        config = postConfig

        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.title

        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        scrollView.pinToContainer()

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])

        generatePostContents()
    }

    func generatePostContents() {
        for element in config.elements {
            let elementView = element.generateContent()
            stackView.addArrangedSubview(elementView)
        }
    }
}
