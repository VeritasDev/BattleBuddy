//
//  BudPointsReward.swift
//  BattleBuddy
//
//  Created by Veritas on 10/3/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct BudPointsReward {
    let points: Int
    let availableDate: Date
    var redeemable: Bool { get { return availableDate.timeIntervalSince1970 < Date().timeIntervalSince1970 } }

    init(nextAvailableDate: Date, pointValue: Int) {
        availableDate = nextAvailableDate
        points = pointValue
    }
}
