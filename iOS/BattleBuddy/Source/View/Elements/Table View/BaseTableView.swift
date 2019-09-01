//
//  BaseTableView.swift
//  BattleBuddy
//
//  Created by Mike on 7/9/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    private let defaultCellHeight: CGFloat = 60.0

    required init?(coder: NSCoder) { fatalError() }

    init(dataSource: UITableViewDataSource, delegate: UITableViewDelegate) {
        super.init(frame: .zero, style: .plain)

        self.delegate = delegate
        self.dataSource = dataSource
        rowHeight = defaultCellHeight
        isScrollEnabled = false
        backgroundColor = UIColor.Theme.background
        separatorColor = UIColor(white: 0.4, alpha: 1.0)
    }
}
