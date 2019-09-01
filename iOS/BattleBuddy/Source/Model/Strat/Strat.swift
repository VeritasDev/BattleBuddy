//
//  Strat.swift
//  BattleBuddy
//
//  Created by Mike on 8/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum CustomStrategy: RandomizableEnum {
    case battleBuddies
    case martyrdom
    case ct
}


struct Strat {
    let customStrat: CustomStrategy?
    let location: Location?
    let firearm: Firearm?
    let armor: Armor?
    let throwables: [Throwable]
    let medicalItems: [Medical]

//    static func createRandomStrat() -> Strat {
//        let randomStrat = CustomStrategy.random()
//        return Strat(customStrat: nil, location: nil, firearm: nil, armor: nil, throwables: [], medicalItems: [])
//    }
}
