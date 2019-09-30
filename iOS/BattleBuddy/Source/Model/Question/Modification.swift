//
//  Modification.swift
//  BattleBuddy
//
//  Created by Veritas on 9/24/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct Modification: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let modType: ModType
    let recoil: Int
    let slots: [Slot]
    let canModInRaid: Bool
    let conflictingItemIds: [String]

    init?(json: [String : Any]) {
        self.json = json
        self.type = .modification

        guard BaseItemUtils.baseItemJsonValid(json),
            let rawModType = json["_kind"] as? String,
            let modType = ModType(rawValue: rawModType),
            let boxedRecoil = json["recoil"] as? NSNumber,
            let slotsJson = json["slots"] as? [String: Any],
            let boxedRaidModdable = json["raidModdable"] as? NSNumber,
            let conflicts = json["conflicts"] as? [String: [String]] else {
                print("ERROR: Mod missing required parameters in json: \(json)")
                return nil
        }

        self.modType = modType
        self.recoil = boxedRecoil.intValue
        self.slots = slotsJson.keys.compactMap {
            guard let json = slotsJson[$0] as? [String: Any] else { return nil }
            return Slot(name: $0, json: json)
        }
        self.canModInRaid = boxedRaidModdable.boolValue

        var conflictingItems: [String] = []
        for key in conflicts.keys { conflictingItems += conflicts[key]! }
        self.conflictingItemIds = conflictingItems
    }
}
