//
//  MainMenuCell.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class MainMenuCell: BaseCardCell {
    let imageView: UIImageView =  {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    let label: UILabel = {
        let label = UILabel()
        // label.textColor = UIColor.label TODO: iOS 13 support
        label.layer.shadowRadius = 2.0
        label.layer.shadowOpacity = 0.9
        label.layer.shadowOffset = CGSize(width: 2, height: 2)
        label.layer.masksToBounds = false
        label.numberOfLines = 0
        return label
    }()
    var menuItem: MainMenuItem? {
        didSet {
            menuItem?.configureCell(self)
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        containerView.addSubview(imageView)

        imageView.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        menuItem?.updateLayoutForCell(self)
    }
}
