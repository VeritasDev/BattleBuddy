//
//  PostElementCell.swift
//  BattleBuddy
//
//  Created by Amaral, Michael on 9/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class PostElementCell: BaseTableViewCell {
    let elementView: UIView

    required init?(coder: NSCoder) { fatalError() }

    init(_ element: PostElement) {
        self.elementView = element.generateContent()
        super.init(style: .default, reuseIdentifier: nil)

        selectionStyle = .none
        contentView.addSubview(elementView)
        separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)

        elementView.pinToContainer()
    }
}
