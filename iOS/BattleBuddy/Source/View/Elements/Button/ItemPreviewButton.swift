//
//  ItemPreviewButton.swift
//  BattleBuddy
//
//  Created by Veritas on 8/10/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit

class ItemPreviewButton: UIButton {
    override var isHighlighted: Bool {
        didSet {
            guard oldValue != self.isHighlighted else { return }

            UIView.animate(withDuration: 0.25, delay: 0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.alpha = self.isHighlighted ? 0.5 : 1
            }, completion: nil)
        }
    }
    var item: Displayable? {
        didSet {
            if let item = item {
                headerLabel.isHidden = false
                headerLabel.font = item.titleFont
                emptyLabel.isHidden = true
                thumbnailImageView.displayableItem = item
                headerLabel.text = item.shortTitle
            } else {
                thumbnailImageView.displayableItem = nil
                headerLabel.text = nil
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
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        view.layer.cornerRadius = 15.0
        view.layer.borderColor = UIColor.Theme.primary.cgColor
        view.layer.borderWidth = 2.0
        view.isUserInteractionEnabled = false
        view.clipsToBounds = true
        return view
    }()
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
        label.isUserInteractionEnabled = false
        return label
    }()
    var emptyLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(white: 0.9, alpha: 1.0)
        label.font = .systemFont(ofSize: 24.0, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        return label
    }()

    var infoStackView = BaseStackView(axis: .vertical, xPaddingCompact: 4, xPaddingRegular: 4, yPadding: 4)

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        thumbnailImageView.isUserInteractionEnabled = false

        addSubview(containerView)
        containerView.addSubview(thumbnailImageView)
        thumbnailImageView.addSubview(headerLabel)
        thumbnailImageView.addSubview(emptyLabel)

        containerView.pinToContainer()
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

        containerView.addSubview(infoStackView)

        let bgView = infoStackView.addBackgroundView()
        bgView.backgroundColor = UIColor.Theme.primary.withAlphaComponent(0.5)

        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            infoStackView.topAnchor.constraint(equalTo: containerView.topAnchor)
            ])
    }

    private func createInfoLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        label.textAlignment = .center
        label.isUserInteractionEnabled = false
        label.text = text
        return label
    }

    func setInfo(_ info: [String]) {
        infoStackView.removeAllArrangedSubviews()

        for string in info {
            let infoLabel = createInfoLabel(string)
            infoStackView.addArrangedSubview(infoLabel)
        }
    }
}
