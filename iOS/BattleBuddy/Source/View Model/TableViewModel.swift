//
//  TableViewModel.swift
//  BattleBuddy
//
//  Created by Veritas on 9/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct GroupedTableViewSection {
    let headerTitle: String?
    let footerTitle: String?
    let cells: [BaseTableViewCell]

    init(headerTitle: String?, footerTitle: String? = nil, cells: [BaseTableViewCell]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.cells = cells
    }
}
