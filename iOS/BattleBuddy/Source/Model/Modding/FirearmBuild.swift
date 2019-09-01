//
//  FirearmBuild.swift
//  BattleBuddy
//
//  Created by Mike on 7/10/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

/*
enum FirearmBuildPreset {
    case none
    case ergo
    case recoil
    case random
}

class FirearmBuild {
    let databaseManager = DependencyManager.shared.databaseManager
    let firearm: Firearm
    let preset: FirearmBuildPreset
    let rootSlots: [ModdableSlot]

    init(firearm: Firearm, preset: FirearmBuildPreset) {
        self.firearm = firearm
        self.preset = preset

        let slots = Array(firearm.slots)
        rootSlots = slots.map { ModdableSlot(name: $0.slotName, compatibleIds: Array($0.compatibleItemIds), isRequired: $0.required) }

        switch preset {
        case .random: buildRandomFirearm()
        case .ergo: buildMaxErgoFirearm()
        default: fatalError("NIMP")
        }
    }

    func buildRandomFirearm() {
        // 1) For all root slots, determine if that slot is required. If it is
        // required, we must attach a mod to it. If not, roll to see if we will
        // attach something to this slot or not.
        for slot in rootSlots {
            if slot.required || RngCalc.coinFlip() {
                recursivelyAddRandomMods(slot: slot)
            }
        }
    }

    func recursivelyAddRandomMods(slot: ModdableSlot) {
        // Get all compatible items for this slot and select a random element
        // from the list, if it has any.
        let compatibleItems = getCompatibleItems(slot: slot)
        guard let randomCompatibleMod = compatibleItems.randomElement() else { return }

        // Attach the mod to this slot.
        add(mod: randomCompatibleMod, toSlot: slot)

        for slot in randomCompatibleMod.slots {
            if slot.required || RngCalc.coinFlip() {
                recursivelyAddRandomMods(slot: slot)
            }
        }
    }

    func buildMaxErgoFirearm() {
        // For each branch in tree...
        // Create all possible combinations of modifications -> return an array of arrays for
        // each branch...
        // Return the highest ergo array total...
//        let allCombinationsForSlot: [[ModdableSlot]] = []
    }

    func recursivelyAddMaxErgoMods(slot: ModdableSlot) {
        // Get all compatible items for this slot and select a random element
        // from the list, if it has any.
//        let compatibleItems = getCompatibleItems(slot: slot)
    }

    func flattenedSlots() -> [ModdableSlot] {
        var allSlots = rootSlots
        for slot in allSlots {
            let descendants = slot.flattenedDescendants()
            allSlots += descendants
        }
        return allSlots
    }

    func slotConflictingWithCandidateMod(mod: ModdableMod, toSlot slot: ModdableSlot) -> ModdableSlot? {
        let allSlots = flattenedSlots()
        for slot in allSlots {
            if let existingMod = slot.attachedMod {
                if existingMod.conflictingItemIds.contains(mod.itemId) || mod.conflictingItemIds.contains(existingMod.itemName) {
                    return slot
                }
            }
        }

        return nil
    }

    func add(mod: ModdableMod, toSlot slot: ModdableSlot) {
        slot.attachedMod = mod
    }

    func removeMod(fromSlot slot: ModdableSlot) {
        slot.attachedMod = nil
    }

    func isComplete() -> Bool {
        let allSlots = flattenedSlots()
        for slot in allSlots {
            if slot.required && slot.attachedMod == nil {
                return false
            }
        }
        return true
    }

    func getCompatibleItems(slot: ModdableSlot) -> [ModdableMod] {
        let modIdsAndConflicts = getModIdsAndConflicts()
        let currentModIds = modIdsAndConflicts.currentModIds
        let conflicts = modIdsAndConflicts.conflicts
        let compatibleItemIds = Array(slot.compatibleItemIds)
        let mods = databaseManager.getMods(modIds: compatibleItemIds)
        var moddableMods: [ModdableMod] = []

        topLoop: for mod in mods {
            // First check to see if this new item conflicts with any existing
            // mods, and if it does, ignore it.
            if conflicts.contains(mod.itemId) {
                continue topLoop
            }

            // Next check to see if any of our existing mods are a conflict with
            // this new incoming mod, and if it does, ignore it.
            for modId in currentModIds {
                if mod.conflicts.contains(modId) {
                    continue topLoop
                }
            }

            let moddableSlots = mod.slots.map { ModdableSlot(name: $0.slotName, compatibleIds: Array($0.compatibleItemIds), isRequired: $0.required) }
            let mod = ModdableMod(id: mod.itemId, name: mod.displayName, image: mod.imageUrl, recoilMod: mod.recoilModifier, ergoMod: mod.ergonomics, availableSlots: Array(moddableSlots), conflictingIds: Array(mod.conflicts))

            moddableMods.append(mod)
        }

        return moddableMods
    }

    private func getModIdsAndConflicts() -> (currentModIds: [String], conflicts: [String]) {
        let allSlots = flattenedSlots()
        var allModIds: [String] = []
        var allConflicts: [String] = []
        for slot in allSlots {
            if let mod = slot.attachedMod {
                allModIds.append(mod.itemId)
                allConflicts += mod.conflictingItemIds
            }
        }
        return (allModIds, allConflicts)
    }
}

 */
