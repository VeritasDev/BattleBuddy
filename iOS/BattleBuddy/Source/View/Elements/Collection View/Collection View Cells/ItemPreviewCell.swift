//
//  ItemPreviewCell.swift
//  BattleBuddy
//
//  Created by Mike on 7/3/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import SDWebImage

class ItemPreviewCell: BaseCardCell {
    var item: Displayable? {
        didSet {
            if let item = item {
                headerLabel.isHidden = false
                headerLabel.font = item.titleFont
                emptyLabel.isHidden = true
                thumbnailImageView.displayableItem = item
                headerLabel.text = item.shortTitle
            } else {
                headerLabel.isHidden = true
                emptyLabel.isHidden = false
            }
        }
    }
    var placeholderText: String? {
        didSet {
            emptyLabel.text = placeholderText
        }
    }
    var thumbnailImageView = BaseImageView(imageSize: .medium)
    var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.layer.shadowRadius = 1.0
        label.layer.shadowOpacity = 1.0
        label.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        label.layer.masksToBounds = false
        label.layer.shadowColor = UIColor.black.cgColor
        return label
    }()
    var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        label.font = .systemFont(ofSize: 24.0, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        containerView.addSubview(thumbnailImageView)
        thumbnailImageView.addSubview(headerLabel)
        thumbnailImageView.addSubview(emptyLabel)

        thumbnailImageView.pinToContainer()

        let padding: CGFloat = 20.0
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: padding),
            headerLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -padding),
            headerLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: padding),
            headerLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, constant: -(2 * padding))
            ])

        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: padding),
            emptyLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -padding),
            emptyLabel.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: padding),
            emptyLabel.widthAnchor.constraint(equalTo: thumbnailImageView.widthAnchor, constant: -(2 * padding)),
            emptyLabel.heightAnchor.constraint(equalTo: thumbnailImageView.heightAnchor, constant: -(2 * padding))
            ])
    }
}
