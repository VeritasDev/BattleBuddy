//
//  DependencyUtils.swift
//  BattleBuddy
//
//  Created by Veritas on 10/11/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

extension BodyZoneType: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .head: return "body_zone_head".local()
        case .thorax: return "body_zone_thorax".local()
        case .stomach: return "body_zone_stomach".local()
        case .rightArm: return "body_zone_right_arm".local()
        case .leftArm: return "body_zone_left_arm".local()
        case .rightLeg: return "body_zone_right_leg".local()
        case .leftLeg: return "body_zone_left_leg".local()
        }
    }
}

extension AimSetting: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .centerOfMass: return "aim_setting_center_mass".local()
        case .upperBody: return "aim_setting_upper_body".local()
        case .headshotsOnly: return "aim_setting_headshots".local()
        case .randomLegMeta: return "aim_setting_random_leg".local()
        case .singleLegMeta: return "aim_setting_single_leg".local()
        case .thoraxOnly: return "aim_setting_thorax".local()
        }
    }
}

extension ChanceSetting: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .always: return "common_always".local()
        case .never: return "common_never".local()
        case .realistic: return "common_realistic".local()
        }
    }
}

extension CombatSimulationResult: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .win: return "simulation_result_win".local()
        case .loss: return "simulation_result_loss".local()
        case .tie: return "simulation_result_tie".local()
        }
    }
}

extension AimSetting: SelectionOption {
    var optionTitle: String { return local() }

    var optionSubtitle: String? {
        switch self {
        case .centerOfMass: return "aim_setting_center_mass_desc".local()
        case .upperBody: return "aim_setting_upper_body_desc".local()
        case .headshotsOnly: return "aim_setting_headshots_desc".local()
        case .randomLegMeta: return "aim_setting_random_leg_desc".local()
        case .singleLegMeta: return "aim_setting_single_leg_desc".local()
        case .thoraxOnly: return "aim_setting_thorax_desc".local()
        }
    }
}

extension Character: SelectionOption {
    var optionTitle: String { return name }
    var optionSubtitle: String? { return nil }
}

extension ChanceSetting: SelectionOption {
    var optionTitle: String { return local() }

    var optionSubtitle: String? {
        switch self {
        case .always: return "common_always_desc".local()
        case .never: return "common_never_desc".local()
        case .realistic: return "common_realistic_desc".local()
        }
    }
}

extension BodyZoneType {
    func getStringValue() -> String {
        switch self {
        case .head: return "head"
        case .thorax: return "thorax"
        case .stomach: return "stomach"
        case .rightArm: return "right_arm"
        case .leftArm: return "left_arm"
        case .rightLeg: return "right_leg"
        case .leftLeg: return "left_leg"
        }
    }
}

extension BEZoneType: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .head: return "body_zone_head".local()
        case .thorax: return "body_zone_thorax".local()
        case .stomach: return "body_zone_stomach".local()
        case .armL: return "body_zone_left_arm".local()
        case .armR: return "body_zone_right_arm".local()
        case .legL: return "body_zone_left_leg".local()
        case .legR: return "body_zone_right_leg".local()
        }
    }

    func getStringValue() -> String {
        switch self {
        case .head: return "head"
        case .thorax: return "thorax"
        case .stomach: return "stomach"
        case .armL: return "left_arm"
        case .armR: return "right_arm"
        case .legL: return "left_leg"
        case .legR: return "right_leg"
        }
    }
}

extension BEArmor {
    static func create(armor: SimulationArmor) -> BEArmor {
        let zoneMap = [
            BodyZoneType.head: BEZoneType.head,
            BodyZoneType.thorax: BEZoneType.thorax,
            BodyZoneType.stomach: BEZoneType.stomach,
            BodyZoneType.leftArm: BEZoneType.armL,
            BodyZoneType.rightArm: BEZoneType.armR,
            BodyZoneType.leftLeg: BEZoneType.legL,
            BodyZoneType.rightLeg: BEZoneType.legR,
        ]
        let zones = armor.resolvedProtectionZones.compactMap { zoneMap[$0] }
        return BEArmor(armorClass: armor.resolvedArmorClass, maxDurability: armor.resolvedMaxDurability, currentDurability: armor.resolvedCurrentDurability, destructibility: armor.resolvedDestructibility, bluntThroughput: armor.resolvedBluntThroughput, protectedZoneTypes: zones)
    }
}

extension BEAmmo {
    static func create(ammo: SimulationAmmo) -> BEAmmo {
        return BEAmmo(damage: ammo.resolvedDamage, penetration: ammo.resolvedPenetration, fragmentation: ammo.resolvedFragmentationChance, armorDamage: ammo.resolvedArmorDamage, hasFragmented: ammo.fragmented)
    }
}
