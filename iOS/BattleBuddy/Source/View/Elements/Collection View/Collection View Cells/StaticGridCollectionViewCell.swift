//
//  StaticGridCollectionViewCell.swift
//  BattleBuddy
//
//  Created by Mike on 6/28/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class StaticGridCollectionViewCell: BaseCardCell {
    let label = UILabel()
    var selectable: Bool = false

    override var isSelected: Bool {
        didSet {
            if selectable {
                if isSelected {
                    containerView.backgroundColor = UIColor.Theme.primary
                    label.textColor = .white
                } else {
                    containerView.backgroundColor = .init(white: 0.85, alpha: 1.0)
                    label.textColor = .black
                }
            }
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        containerView.backgroundColor = UIColor.Theme.primary

        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 0
        containerView.addSubview(label)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        label.frame = CGRect.init(x: 10, y: 10, width: containerView.frame.width - 20, height: containerView.frame.height - 20)
    }
}
