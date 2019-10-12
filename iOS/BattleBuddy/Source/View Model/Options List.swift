//
//  Options List.swift
//  BattleBuddy
//
//  Created by Veritas on 10/11/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

protocol SelectionOption {
    var optionTitle: String { get }
    var optionSubtitle: String? { get }
}

protocol SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption)
}
