//
//  ItemPreviewCardView.swift
//  BattleBuddy
//
//  Created by Mike on 7/6/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ItemPreviewCardView: BaseCardView {
    var item: Displayable? {
        didSet {
            guard let item = item else { fatalError() }
            thumbnailImageView.displayableItem = item
            headerLabel.text = item.title
        }
    }

    var thumbnailImageView = BaseImageView(imageSize: .large)
    var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()

    required init(coder aDecoder: NSCoder) { fatalError("NIMP") }

    init() {
        super.init(frame: .zero)

        containerView.addSubview(thumbnailImageView)

        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
    }
}
