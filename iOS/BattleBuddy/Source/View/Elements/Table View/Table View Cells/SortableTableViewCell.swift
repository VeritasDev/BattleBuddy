//
//  SortableTableViewCell.swift
//  BattleBuddy
//
//  Created by Mike on 7/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SortableTableViewCell: BaseTableViewCell {
    static let reuseId = "SortableTableViewCell"
    var item: Sortable? {
        didSet {
            guard let params = item?.params else { fatalError() }
            guard params.count == labels.count else { fatalError() }

            for index in 0..<labels.count {
                labels[index].text = item?.valueForParam(params[index])
            }
        }
    }
    let stackView = BaseStackView(axis: .horizontal)
    var labels: [UILabel] = []

    var isSelectedOption: Bool { didSet { labels.forEach { $0.textColor = isSelectedOption ? UIColor.Theme.primary : .white } } }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(config: SortConfiguration) {
        isSelectedOption = false

        super.init(style: .default, reuseIdentifier: AmmoStatsCell.reuseId)

        contentView.addSubview(stackView)
        stackView.pinToContainer()

        for _ in config.params {
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
            label.textColor = .white
            labels.append(label)

            stackView.addArrangedSubview(label)
        }
    }
}
