//
//  ItemFactory.swift
//  BattleBuddy
//
//  Created by Mike on 6/19/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class ItemFactory {
    class func createItem(json: [String: Any]) -> BaseItem? {
        guard let kind = json["_kind"] as? String else { return nil }

        switch kind {
        case ItemType.firearm.rawValue: return Firearm(json: json)
        case ItemType.melee.rawValue: return MeleeWeapon(json: json)
        case ItemType.ammo.rawValue: return Ammo(json: json)
        case ItemType.armor.rawValue: return Armor(json: json)
        case ItemType.medical.rawValue: return Medical(json: json)
        case ItemType.throwable.rawValue: return Throwable(json: json)
        default: return nil
        }
    }
}
