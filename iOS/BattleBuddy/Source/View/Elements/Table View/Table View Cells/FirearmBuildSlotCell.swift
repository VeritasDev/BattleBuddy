//
//  FirearmBuildSlotCell.swift
//  BattleBuddy
//
//  Created by Mike on 8/9/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class FirearmBuildSlotCell: UITableViewCell {
    static let reuseId = "FirearmBuildSlotCell"
    var slot: ModdableSlot? {
        didSet {
            guard let safeSlot = slot else { return }

            textLabel?.text = safeSlot.local()

            if let attachedMod = safeSlot.attachedMod {
                imageView?.sd_setImage(with: attachedMod.imageUrl)
                detailTextLabel?.text = attachedMod.itemName
                detailTextLabel?.textColor = .black
            } else if safeSlot.required {
                detailTextLabel?.text = "required".local()
                detailTextLabel?.textColor = .red
            } else {
                detailTextLabel?.text = nil
                detailTextLabel?.textColor = .black
            }
            setNeedsLayout()
        }
    }

    let containerStackView = BaseStackView(axis: .horizontal)
    lazy var modImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let statsStackView = BaseStackView()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .subtitle, reuseIdentifier: FirearmBuildSlotCell.reuseId)

        accessoryType = .disclosureIndicator

        contentView.addSubview(containerStackView)

        containerStackView.addArrangedSubview(modImageView)

        containerStackView.addArrangedSubview(statsStackView)

        containerStackView.pinToContainer()
        modImageView.constrainWidth(50.0)
        modImageView.constrainHeight(50.0)

        textLabel?.numberOfLines = 0
        textLabel?.font = .systemFont(ofSize: 14.0, weight: .black)
        textLabel?.textColor = .black
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.font = .systemFont(ofSize: 18.0, weight: .light)
        imageView?.contentMode = .scaleAspectFit
    }
}
