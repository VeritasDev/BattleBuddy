//
//  ItemDetailsViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemDetailsViewController: BaseStackViewController, ItemDetailsSectionDelegate {
    var configuration: ItemDetailsConfiguration
    let itemImageView = BaseImageView(imageSize: .large)
    let insetContentStackView = BaseStackView(xPaddingCompact: 18.0, xPaddingRegular: 20.0)
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .light)
        label.textColor = UIColor(white: 0.9, alpha: 1.0)
        return label
    }()

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    init(_ configuration: ItemDetailsConfiguration) {
        self.configuration = configuration
        print(configuration.item.id)

        super.init(BaseStackView(xPaddingCompact: 0.0, xPaddingRegular: 0.0))

        self.configuration.delegate = self

        itemImageView.displayableItem = configuration.item as? Displayable
        itemImageView.contentMode = .scaleAspectFill
        stackView.addArrangedSubview(itemImageView)

        descriptionLabel.text = configuration.item.displayDescription

        stackView.addArrangedSubview(insetContentStackView)
        insetContentStackView.addArrangedSubview(descriptionLabel)

        for arrangedSubview in configuration.getArrangedSubviews() {
            stackView.addArrangedSubview(arrangedSubview)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = configuration.item.displayName

        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: itemImageView, attribute: .height, relatedBy: .equal, toItem: itemImageView, attribute: .width, multiplier: 0.56, constant: 0),
            itemImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor)
            ])
    }

    // Item details section delegate
    func showLoading(show: Bool) {
        if show {
            showLoading()
        } else {
            hideLoading()
        }
    }

    func showViewController(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
