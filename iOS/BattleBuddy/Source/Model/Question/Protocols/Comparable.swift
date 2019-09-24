//
//  Comparable.swift
//  BattleBuddy
//
//  Created by Mike on 7/17/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol Comparable: Displayable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String
}

enum ComparableProperty: Localizable {
    // Firearm
    case fireRate
    case ergonomics
    case verticalRecoil
    case horizontalRecoil
    case effectiveRange

    // Ammo
    case penetration
    case damage
    case armorDamage
    case fragChance
    case muzzleVelocity

    // Armor
    case armorClass
    case armorDurability
    case armorZones
    case speedPenalty
    case turnSpeedPenalty
    case ergoPenalty
    case hearingPenalty

    // Medical
    case useCount
    case useTime
    case effectDuration
    case removesBloodloss
    case removesContusion
    case removesFracture
    case removesPain

    // Throwables
    case fuseTime
    case explosionRadiusMin
    case explosionRadiusMax
    case fragmentationCount

    // Melee
    case stabDamage
    case stabRate
    case stabRange
    case slashDamage
    case slashRate
    case slashRange

    func local(short: Bool = false) -> String {
        switch self {
        case .fireRate: return Localized("fire_rate")
        case .ergonomics: return Localized("ergonomics")
        case .verticalRecoil: return Localized("vertical_recoil")
        case .horizontalRecoil: return Localized("horizontal_recoil")
        case .effectiveRange: return Localized("effective_range")
        case .penetration: return Localized("penetration")
        case .damage: return Localized("damage")
        case .armorDamage: return Localized("armor_damage")
        case .fragChance: return Localized("frag_chance")
        case .muzzleVelocity: return Localized("muzzle_velocity")
        case .armorClass: return Localized("armor_class")
        case .armorDurability: return Localized("armor_points")
        case .armorZones: return Localized("armor_zones")
        case .speedPenalty: return Localized("speed_penalty_full")
        case .turnSpeedPenalty: return Localized("turn_speed_penalty_full")
        case .ergoPenalty: return Localized("ergo_penalty_full")
        case .hearingPenalty: return Localized("hearing_penalty_full")
        case .useCount: return Localized("use_count")
        case .useTime: return Localized("use_time")
        case .effectDuration: return Localized("effect_duration")
        case .removesBloodloss: return Localized("removes_bloodloss")
        case .removesContusion: return Localized("removes_contusion")
        case .removesFracture: return Localized("removes_fracture")
        case .removesPain: return Localized("removes_pain")
        case .fuseTime: return Localized("fuse_time")
        case .explosionRadiusMin: return Localized("explosion_radius_min")
        case .explosionRadiusMax: return Localized("explosion_radius_max")
        case .fragmentationCount: return Localized("fragmentation_count")
        case .stabDamage: return Localized("stab_dmg")
        case .stabRate: return Localized("stab_rate")
        case .stabRange: return Localized("stab_range")
        case .slashDamage: return Localized("slash_dmg")
        case .slashRate: return Localized("slash_rate")
        case .slashRange: return Localized("slash_range")
        }
    }

    static func propertiesForType(type: ComparablePropertyType) -> [ComparableProperty] {
        switch type {
        case .firearm: return [.fireRate, .ergonomics, .verticalRecoil, .horizontalRecoil, .effectiveRange]
        case .ammo: return [.penetration, .damage, .armorDamage, .fragChance, .muzzleVelocity]
        case .armor: return [.armorClass, .armorDurability, .armorZones, .speedPenalty, .turnSpeedPenalty, .ergoPenalty]
        case .medical: return [.useCount, .useTime, .effectDuration, .removesBloodloss, .removesFracture, .removesPain, .removesContusion]
        case .throwable: return [.fuseTime, .fragmentationCount, .explosionRadiusMin, explosionRadiusMax]
        case .melee: return [.stabDamage, .stabRate, stabRange, .slashDamage, slashRate, .slashRange]
        }
    }
}

extension Firearm: Comparable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String {
        switch property {
        case .fireRate: return String(fireRate) + " " + Localized("rpm")
        case .ergonomics: return String(ergonomics)
        case .verticalRecoil: return String(verticalRecoil)
        case .horizontalRecoil: return String(horizontalRecoil)
        case .effectiveRange: return String(effectiveDistance) + Localized("meters_abbr")
        default: fatalError()
        }
    }
}

extension Ammo: Comparable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String {
        switch property {
        case .penetration: return String(penetration)
        case .damage: return String(Int(resolvedDamage))
        case .fragChance: return String(Int(fragChance * 100)) + "%"
        case .armorDamage: return String(Int(resolvedArmorDamage))
        case .muzzleVelocity: return String(muzzleVelocity)
        default: fatalError()
        }
    }
}

extension Armor: Comparable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String {
        switch property {
        case .armorClass: return String(armorClass.local())
        case .armorDurability: return String(maxDurability)
        case .armorZones: return String(armorZoneConfig.zoneCount())
        case .speedPenalty: return String(penalties.movementSpeed)
        case .turnSpeedPenalty: return String(penalties.turnSpeed)
        case .ergoPenalty: return String(penalties.ergonomics)
        case .hearingPenalty: return penalties.hearing.local()
        default: fatalError()
        }
    }
}

extension Medical: Comparable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String {
        switch property {
        case .useCount: return String(totalUses)
        case .useTime: return String(useTime)
        case .effectDuration: return String(effectDuration) + Localized("seconds_abbr")
        case .removesBloodloss: return removesBloodloss ? Localized("yes") : Localized("no")
        case .removesContusion: return removesContusion ? Localized("yes") : Localized("no")
        case .removesFracture: return removesFracture ? Localized("yes") : Localized("no")
        case .removesPain: return removesPain ? Localized("yes") : Localized("no")
        default: fatalError()
        }
    }
}

extension Throwable: Comparable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String {
        switch property {
        case .explosionRadiusMin: return String(explosionRadiusMin) + Localized("meters_abbr")
        case .explosionRadiusMax: return String(explosionRadiusMax) + Localized("meters_abbr")
        case .fragmentationCount: return String(fragmentationCount)
        case .fuseTime: return String(fuseTime) + Localized("seconds_abbr")
        default: fatalError()
        }
    }
}

extension MeleeWeapon: Comparable {
    func getValueStringForProperty(_ property: ComparableProperty) -> String {
        switch property {
        case .stabDamage: return String(stabDamage)
        case .stabRate: return String(stabRate)
        case .stabRange: return String(stabRange) + "meters_abbr".local()
        case .slashDamage: return String(slashDamage)
        case .slashRate: return String(slashRate)
        case .slashRange: return String(slashRange) + "meters_abbr".local()
        default: fatalError()
        }
    }
}
