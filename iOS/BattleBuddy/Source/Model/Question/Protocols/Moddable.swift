//
//  Moddable.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum ModType: String, CaseIterable, Localizable {
    case pistolGrip = "modificationPistolgrip"
    case receiver = "modificationReceiver"
    case magazine = "magazine"
    case sight = "modificationSight"
    case sightSpecial = "modificationSightSpecial"
    case stock = "modificationStock"
    case handguard = "modificationHandguard"
    case barrel = "modificationBarrel"
    case device = "modificationDevice"
    case foregrip = "modificationForegrip"
    case gasBlock = "modificationGasblock"
    case charge = "modificationCharge"
    case mount = "modificationMount"
    case muzzle = "modificationMuzzle"
    case gogglesSpecial = "modificationGogglesSpecial"
    case goggles = "modificationGoggles"
    case bipod = "modificationBipod"
    case launcher = "modificationLauncher"

    func local(short: Bool = false) -> String {
        switch self {
        case .pistolGrip: return "mod_pistol_grip".local()
        case .receiver: return "mod_receiver".local()
        case .sight: return "mod_sight".local()
        case .sightSpecial: return "mod_sight_special".local()
        case .stock: return "mod_stock".local()
        case .magazine: return "mod_magazine".local()
        case .handguard: return "mod_handguard".local()
        case .barrel: return "mod_barrel".local()
        case .device: return "mod_device".local()
        case .foregrip: return "mod_foregrip".local()
        case .gasBlock: return "mod_gas_block".local()
        case .charge: return "mod_charge".local()
        case .mount: return "mod_mount".local()
        case .muzzle: return "mod_".local()
        case .gogglesSpecial: return "mod_goggles_special".local()
        case .goggles: return "mod_goggles".local()
        case .bipod: return "mod_bipod".local()
        case .launcher: return "mod_launcher".local()
        }
    }
}

/*
protocol Moddable {
    var slots: [ModSlot] { get }
    var conflicts: [String] { get }
    func getAllCompatibleAttachments() -> [ModType: Set<Modification>]
    func attach(mod: Modification, toSlot destinationSlot: ModSlot) -> Bool
}

//func test: Moddable {
//    if let rawSlots = itemJson["slots"] as? [String: Any] {
//        for slotName in rawSlots.keys {
//            guard let slotConfig = rawSlots[slotName] as? [String: Any],
//                let boxedRequired = slotConfig["required"] as? NSNumber,
//                let filter = slotConfig["filter"] as? [String: [String]] else {
//                    print("|| SERIALIZATION ERROR || Slot json not parsed: \(itemJson)")
//                    return nil
//            }
//
//            var compatibleItemIds: [String] = []
//            for filterName in filter.keys {
//                guard let compatibleItemIdsForFilter = filter[filterName] else { continue }
//                compatibleItemIds += compatibleItemIdsForFilter
//            }
//
//            let itemSlot = ItemSlot(name: slotName, compatibleItems: compatibleItemIds, isRequired: boxedRequired.boolValue)
//            slots.append(itemSlot)
//        }
//    }
//
//    if let rawConflicts = itemJson["conflicts"] as? [String: [String]] {
//        for modTypeKey in rawConflicts.keys {
//            let conflictingIdsForType = rawConflicts[modTypeKey]!
//            conflicts.append(objectsIn: conflictingIdsForType)
//        }
//    }
//}

extension Moddable {

    var slots: [ModSlot] {
        return [] // TODO
    }

    var conflicts: [String] {
        guard let rawConflicts = itemJson["conflicts"] as? [String: [String]] else { return [] }
        var allConflicts: [String] = []
        for modTypeKey in rawConflicts.keys {
            let conflictingIdsForType = rawConflicts[modTypeKey]!
            allConflicts.append(contentsOf: conflictingIdsForType)
        }
        return allConflicts
    }

    func getAllCompatibleAttachments() -> [ModType: Set<Modification>] {
//        var allMods: Set<Modification> = []

//        for slot in slots {
//            allMods = allMods.union(Set(slot.getAllCompatibleAttachments()))
//        }
        //
        //        var modMap: [ModType: Set<Modification>] = [:]
        //        for modType in ModType.allCases {
        //            modMap[modType] = []
        //        }
        //
        //        for mod in allMods {
        //            modMap[mod.modType]!.insert(mod)
        //        }
        //
        return [:]
    }

    func attach(mod: Modification, toSlot destinationSlot: ModSlot) -> Bool {
        //        for index in 0..<slots.count {
        //            let attachedToSlot = slots[index].attach(mod: mod, toSlot: destinationSlot)
        //            if let attachedToSlot = attachedToSlot {
        //                DependencyManager.shared.databaseManager.realm.beginWrite()
        //                slots[index] = attachedToSlot
        //                try! DependencyManager.shared.databaseManager.realm.commitWrite()
        //                return true
        //            }
        //        }
        return false
    }
}
 */
