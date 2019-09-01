//
//  TraderMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class TraderMenuViewController: MainMenuCollectionViewController {
    required init(items: [MainMenuItem]) { fatalError("NIMP") }
    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    required init() {
        super.init(items: [
//            MainMenuItem(type: .prapor, compactSize: .medium, regularSize: .large),
//            MainMenuItem(type: .therapist, compactSize: .medium, regularSize: .large),
//            MainMenuItem(type: .skier, compactSize: .medium, regularSize: .large),
//            MainMenuItem(type: .peacekeeper, compactSize: .medium, regularSize: .large),
//            MainMenuItem(type: .mechanic, compactSize: .medium, regularSize: .large),
//            MainMenuItem(type: .ragman, compactSize: .medium, regularSize: .large)
            ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Localized("main_menu_traders")
    }
}
