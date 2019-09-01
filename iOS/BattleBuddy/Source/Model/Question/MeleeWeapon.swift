//
//  MeleeWeapon.swift
//  BattleBuddy
//
//  Created by Mike on 6/29/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct MeleeWeapon: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let stabDamage: Int
    let stabRate: Int
    let stabConsumption: Int
    let stabRange: Float

    let slashDamage: Int
    let slashRate: Int
    let slashConsumption: Int
    let slashRange: Float

    init?(json: [String: Any]) {
        self.json = json
        self.type = .melee

        guard BaseItemUtils.baseItemJsonValid(json),
            let stabDetails = json["stab"] as? [String: NSNumber],
            let slashDetails = json["slash"] as? [String: NSNumber],
            let boxedStabDamage = stabDetails["damage"],
            let boxedStabRate = stabDetails["rate"],
            let boxedStabConsumption = stabDetails["consumption"],
            let boxedStabRange = stabDetails["range"],
            let boxedSlashDamage = slashDetails["damage"],
            let boxedSlashRate = slashDetails["rate"],
            let boxedSlashConsumption = slashDetails["consumption"],
            let boxedSlashRange = slashDetails["range"] else {
                return nil
        }

        stabDamage = boxedStabDamage.intValue
        stabRate = boxedStabRate.intValue
        stabConsumption = boxedStabConsumption.intValue
        stabRange = boxedStabRange.floatValue
        slashDamage = boxedSlashDamage.intValue
        slashRate = boxedSlashRate.intValue
        slashConsumption = boxedSlashConsumption.intValue
        slashRange = boxedSlashRange.floatValue
    }
}
