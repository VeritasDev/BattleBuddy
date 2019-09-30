//
//  Slot.swift
//  BattleBuddy
//
//  Created by Veritas on 9/24/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct Slot {
    let name: String
    let compatibleItemIds: [String]
    var attachedMod: Modification?
    let required: Bool
    let conflictingItemIds: [String]

    mutating func attachMod(_ mod: Modification) { attachedMod = mod }
    mutating func detachMod() { attachedMod = nil }

    init?(name: String, json: [String: Any]) {
        guard let filter = json["filter"] as? [String: [String]],
            let boxedRequired = json["required"] as? NSNumber,
            let conflicts = json["conflicts"] as? [String: [String]] else { return nil }

        self.name = name

        var itemIds: [String] = []
        for ids in filter.values { itemIds += ids }
        self.compatibleItemIds = itemIds

        self.required = boxedRequired.boolValue

        var conflictIds: [String] = []
        for ids in conflicts.values { conflictIds += ids }
        self.conflictingItemIds = conflictIds
    }
}
