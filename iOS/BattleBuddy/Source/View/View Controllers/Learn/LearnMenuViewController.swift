//
//  LearnMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class LearnMenuViewController: MainMenuCollectionViewController {
    required init(items: [MainMenuItem]) { fatalError("NIMP") }
    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    required init() {
        super.init(items: [
//            MainMenuItem(type: .shootingRange, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .priceCheck, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .combatSim, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .penChanceCalc, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .healthCalc, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .soundTraining, compactSize: .medium, regularSize: .large),
            MainMenuItem(type: .ballistics, compactSize: .medium, regularSize: .large),
            ])
    }
}
