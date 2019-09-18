//
//  FirearmComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

enum FirearmComparisonPreset: Localizable {
    case semiAutoRifles
    case fullAutoRifles
    case riflesMatchingCaliber
    case rifles
    case fullAutoMatchingCaliber
    case semiAutoPistols
    case fullAutoPistols
    case pistolsMatchingCaliber
    case pistols
    case manualShotguns
    case shotguns
    case smgsMatchingCaliber
    case smgs
    case boltActionSnipers
    case snipersAndDmrs
    case dmrs

    func local(short: Bool = false) -> String {
        switch self {
        case .semiAutoRifles: return "compare_preset_semi_auto_rifle".local()
        case .fullAutoRifles: return "compare_preset_full_auto_rifles".local()
        case .riflesMatchingCaliber: return "compare_preset_rifles_caliber_match".local()
        case .rifles: return "compare_preset_rifles".local()
        case .fullAutoMatchingCaliber: return "compare_preset_full_auto_caliber_match".local()
        case .semiAutoPistols: return "compare_preset_semi_auto_pistols".local()
        case .fullAutoPistols: return "compare_preset_full_auto_pistols".local()
        case .pistolsMatchingCaliber: return "compare_preset_pistols_caliber_match".local()
        case .pistols: return "compare_preset_pistols".local()
        case .manualShotguns: return "compare_preset_manual_shotguns".local()
        case .shotguns: return "compare_preset_shotguns".local()
        case .smgsMatchingCaliber: return "compare_preset_smgs_caliber_match".local()
        case .smgs: return "compare_preset_smgs".local()
        case .boltActionSnipers: return "compare_preset_bolt_snipers".local()
        case .snipersAndDmrs: return "compare_preset_snipers_and_dmrs".local()
        case .dmrs: return "compare_preset_dmrs".local()
        }
    }
}

struct FirearmComparison: ItemComparison {
    var propertyType: ComparablePropertyType = .firearm
    var allItems: [Comparable]
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var recommendedOptionsTitle: String?
    var secondaryRecommendedOptions: [Comparable]
    var secondaryRecommendedOptionsTitle: String?
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .firearm)
    var preferRecommended: Bool = true

    init(_ initialFirearm: Firearm? = nil, allFirearms: [Firearm]) {
        allItems = allFirearms
        if let firearm = initialFirearm {
            let presets = FirearmComparison.resolvePresetsFromFirearm(firearm)
            let itemsForPreset = FirearmComparison.filterItems(allFirearms, firearmBeingCompared: firearm, presets: presets)
            itemsBeingCompared = itemsForPreset.primary
            recommendedOptions = itemsForPreset.primary
            recommendedOptionsTitle = presets.primary.local()
            secondaryRecommendedOptions = itemsForPreset.secondary
            secondaryRecommendedOptionsTitle = presets.secondary?.local()
            possibleOptions = itemsForPreset.remaining
        } else {
            itemsBeingCompared = []
            recommendedOptions = []
            secondaryRecommendedOptions = []
            possibleOptions = allFirearms
        }
    }

    private static func resolvePresetsFromFirearm(_ firearm: Firearm) -> (primary: FirearmComparisonPreset, secondary: FirearmComparisonPreset?) {
        switch firearm.firearmType {
        case .assaultCarbine, .assaultRifle, .machinegun:
            return (!firearm.fullAuto && !firearm.burst) ? (.semiAutoRifles, .riflesMatchingCaliber) : (.fullAutoMatchingCaliber, .fullAutoRifles)
        case .sniperRifle:
            if firearm.action == .bolt {
                return (.boltActionSnipers, .snipersAndDmrs)
            } else if (firearm.fullAuto) {
                return (.fullAutoMatchingCaliber, .fullAutoRifles)
            } else {
                return (.snipersAndDmrs, nil)
            }
        case .designatedMarksmanRifle:
            return (.dmrs, .riflesMatchingCaliber)
        case .pistol:
            return (!firearm.fullAuto && !firearm.burst) ? (.semiAutoPistols, .pistolsMatchingCaliber) : (.fullAutoPistols, .pistolsMatchingCaliber)
        case .shotgun:
            return firearm.action.isManualAction() ? (.manualShotguns, .shotguns) : (.shotguns, nil)
        case .submachineGun:
            return (.smgsMatchingCaliber, .smgs)
        }
    }

    private static func filterItems(_ items: [Firearm], firearmBeingCompared: Firearm, presets: (primary: FirearmComparisonPreset, secondary: FirearmComparisonPreset?)) -> (primary: [Comparable], secondary: [Comparable], remaining: [Comparable]) {
        let primary = filterItems(items, firearmBeingCompared: firearmBeingCompared, preset: presets.primary)
        var secondary = filterItems(items, firearmBeingCompared: firearmBeingCompared, preset: presets.secondary)

        // Filter out duplicates from the other arrays in case there's overlap
        var remaining = items
        for recommended in primary {
            remaining.removeAll{ $0.id == recommended.identifier }
            secondary.removeAll{ $0.identifier == recommended.identifier }
        }

        for recommended in secondary {
            remaining.removeAll{ $0.id == recommended.identifier }
        }

        return (primary, secondary, remaining)
    }

    private static func filterItems(_ items: [Firearm], firearmBeingCompared: Firearm, preset: FirearmComparisonPreset?) -> [Comparable] {
        guard let preset = preset else { return [] }

        let types: [FirearmType]
        var modeRestriction: FireModeRestriction = .none
        var actionRestriction: ActionRestriction = .none
        var matchingCaliber = false

        switch preset {
        case .semiAutoRifles:
            types = [.assaultCarbine, .assaultRifle, .designatedMarksmanRifle, .machinegun, .sniperRifle]
            modeRestriction = .semiAutoOnly
        case .fullAutoRifles:
            types = [.assaultCarbine, .assaultRifle, .designatedMarksmanRifle, .machinegun, .sniperRifle]
            modeRestriction = .fullAutoCapable
        case .riflesMatchingCaliber:
            types = [.assaultCarbine, .assaultRifle, .designatedMarksmanRifle, .machinegun, .sniperRifle]
            modeRestriction = .fullAutoCapable
            matchingCaliber = true
        case .rifles:
            types = [.assaultCarbine, .assaultRifle, .designatedMarksmanRifle, .machinegun, .sniperRifle]
        case .fullAutoMatchingCaliber:
            types = []
            modeRestriction = .fullAutoCapable
            matchingCaliber = true
        case .semiAutoPistols:
            types = [.pistol]
            modeRestriction = .semiAutoOnly
        case .fullAutoPistols:
            types = [.pistol]
            modeRestriction = .fullAutoCapable
        case .pistolsMatchingCaliber:
            types = [.pistol]
            matchingCaliber = true
        case .pistols:
            types = [.pistol]
        case .manualShotguns:
            actionRestriction = .manualOnly
            types = [.shotgun]
        case .shotguns:
            types = [.shotgun]
        case .smgsMatchingCaliber:
            types = [.submachineGun]
            matchingCaliber = true
        case .smgs:
            types = [.submachineGun]
        case .boltActionSnipers:
            types = [.sniperRifle]
            actionRestriction = .boltOnly
        case .snipersAndDmrs:
            types = [.sniperRifle, .designatedMarksmanRifle]
        case .dmrs:
            types = [.designatedMarksmanRifle]
        }

        let items = items.filter {
            if !types.isEmpty && !types.contains($0.firearmType) { return false }
            if matchingCaliber && firearmBeingCompared.caliber != $0.caliber { return false }

            let action = $0.action
            switch modeRestriction {
            case .fullAutoCapable: if !$0.fullAuto { return false }
            case .semiAutoOnly: if ($0.fullAuto || action == .bolt || action == .pump) { return false }
            default: break
            }

            switch actionRestriction {
            case .auto: if action == .bolt || action == .pump { return false }
            case .boltOnly: if action != .bolt { return false }
            case .pumpOnly: if action != .pump { return false }
            case .manualOnly: if action != .bolt && action != .pump { return false }
            default: break
            }

            return true
        }
        return items
    }

    func getComparedItemsSummaryMap() -> [ComparableProperty: PropertyRange] {
        var fireRateRange = PropertyRange()
        var ergoRange = PropertyRange()
        var vRecoilRange = PropertyRange()
        var hRecoilRange = PropertyRange()
        var effectiveDistRange = PropertyRange()

        for case let firearm as Firearm in allItems {
            fireRateRange.updatedRangeIfNeeded(candidateValue: Float(firearm.fireRate))
            ergoRange.updatedRangeIfNeeded(candidateValue: Float(firearm.ergonomics))
            vRecoilRange.updatedRangeIfNeeded(candidateValue: Float(firearm.verticalRecoil))
            hRecoilRange.updatedRangeIfNeeded(candidateValue: Float(firearm.horizontalRecoil))
            effectiveDistRange.updatedRangeIfNeeded(candidateValue: Float(firearm.effectiveDistance))
        }

        return [
            .fireRate: fireRateRange,
            .ergonomics: ergoRange,
            .verticalRecoil: vRecoilRange,
            .horizontalRecoil: hRecoilRange,
            .effectiveRange: effectiveDistRange,
        ]
    }

    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float {
        guard let firearm = item as? Firearm else { fatalError() }
        let range = getComparedItemsSummaryMap()[property]!

        switch property {
        case .fireRate: return scaledValue(propertyValue: Float(firearm.fireRate), range: range)
        case .ergonomics: return scaledValue(propertyValue: Float(firearm.ergonomics), range: range)
        case .verticalRecoil: return scaledValue(propertyValue: Float(firearm.verticalRecoil), range: range)
        case .horizontalRecoil: return scaledValue(propertyValue: Float(firearm.horizontalRecoil), range: range)
        case .effectiveRange: return scaledValue(propertyValue: Float(firearm.effectiveDistance), range: range)
        default: fatalError()
        }
    }
}
