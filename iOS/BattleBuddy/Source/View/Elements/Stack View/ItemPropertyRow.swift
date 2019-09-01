//
//  ItemPropertyRow.swift
//  BattleBuddy
//
//  Created by Mike on 7/7/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct ItemPropertyViewModel {
    let nameString: String
    let valueString: String
    let valueColor: UIColor
}

class ItemPropertyRow: BaseStackView {
    required init(coder: NSCoder) { fatalError("NIMP") }

    init(properties: [ItemPropertyViewModel]) {
        super.init(axis: .horizontal, distribution: .fillEqually, xPaddingCompact: 10.0)

        for property in properties {
            let propertyView = BaseStackView(axis: .vertical, xPaddingCompact: 2.0)

            let valueLabel = UILabel()
            valueLabel.textAlignment = .center
            valueLabel.font = .systemFont(ofSize: 25, weight: .semibold)
            valueLabel.text = property.valueString
            valueLabel.textColor = property.valueColor
            propertyView.addArrangedSubview(valueLabel)

            let nameLabel = UILabel()
            nameLabel.text = property.nameString
            nameLabel.textAlignment = .center
            nameLabel.textColor = .black
            nameLabel.font = .systemFont(ofSize: 16, weight: .black)
            nameLabel.numberOfLines = 0
            propertyView.addArrangedSubview(nameLabel)

            addArrangedSubview(propertyView)
        }
    }
}
