//
//  Modding.swift
//  BattleBuddy
//
//  Created by Mike on 8/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class ModdableSlot: Localizable {
    var slotName: String
    var required: Bool
    var compatibleItemIds: [String]
    var attachedMod: ModdableMod?

    init(name: String, compatibleIds: [String], isRequired: Bool) {
        slotName = name
        compatibleItemIds = compatibleIds
        required = isRequired
    }

    func flattenedDescendants() -> [ModdableSlot] {
        return attachedMod?.flattenedDescendants() ?? []
    }

    func local(short: Bool = false) -> String {
        switch slotName {
        case "barrel": return Localized("slot_barrel")
        case "handguard": return Localized("slot_handguard")
        case "sightRear": return Localized("slot_rear_sight")
        case "sightFront": return Localized("slot_front_sight")
        case "magazine": return Localized("slot_magazine")
        case "pistolGrip": return Localized("slot_pistol_grip")
        case "muzzle": return Localized("slot_muzzle")
        case "gasBlock": return Localized("slot_gas_block")
        case "bipod": return Localized("slot_bipod")
        case "charge": return Localized("slot_charging_handle")
        case "flashlight": return Localized("slot_flashlight")
        case "foregrip": return Localized("slot_foregrip")
        case "launcher": return Localized("slot_launcher")
        case "nvg": return Localized("slot_nvg")
        case "receiver": return Localized("slot_receiver")
        case "stock": return Localized("slot_stock")
        case let str where str.contains("equipment_"): return Localized("slot_equipment")
        case let str where str.contains("mount_"): return Localized("slot_mount")
        case let str where str.contains("scope_"): return Localized("slot_scope")
        case let str where str.contains("tactical_"): return Localized("slot_tactical")
        default: return slotName
        }
    }
}

class ModdableMod {
    var itemId: String
    var itemName: String
    var imageUrl: URL?
    var recoil: Int
    var ergo: Int
    var slots: [ModdableSlot]
    var conflictingItemIds: [String]

    init(id: String, name: String, image: URL?, recoilMod: Int, ergoMod: Int, availableSlots: [ModdableSlot] = [], conflictingIds: [String]) {
        itemId = id
        itemName = name
        imageUrl = image
        recoil = recoilMod
        ergo = ergoMod
        slots = availableSlots
        conflictingItemIds = conflictingIds
    }

    func flattenedDescendants() -> [ModdableSlot] {
        var allSlots: [ModdableSlot] = slots
        for slot in slots {
            let descendants = slot.flattenedDescendants()
            allSlots += descendants
        }
        return allSlots
    }

    static func == (lhs: ModdableMod, rhs: ModdableMod) -> Bool {
        return lhs.itemId == rhs.itemId
    }
}
