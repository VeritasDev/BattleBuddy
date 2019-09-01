//
//  FilterViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/26/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func didGenerateFilter(filter: ItemFilter)
}

class FilterViewController: UIViewController {
    var delegate: FilterViewControllerDelegate?

    func generateFilter() -> ItemFilter {
        return ItemFilter()
    }
    func onApply() {
        if let delegate = delegate {
            delegate.didGenerateFilter(filter: generateFilter())
        }
    }
}
