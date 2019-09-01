//
//  Random.swift
//  BattleBuddy
//
//  Created by Mike on 8/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

protocol Randomizable {
    static func random() -> Self
}

protocol RandomizableEnum: Randomizable, CaseIterable { }

extension RandomizableEnum {
    static func random() -> Self {
        var g = SystemRandomNumberGenerator()
        return self.allCases.randomElement(using: &g)!
    }
}

class RngCalc {
    static func satisfiesRandomPercentChance(chance: Int) -> Bool {
        let randomRoll = Int.random(in: 0 ..< 100)
        return randomRoll < chance
    }

    static func coinFlip() -> Bool {
        return satisfiesRandomPercentChance(chance: 50)
    }
}
