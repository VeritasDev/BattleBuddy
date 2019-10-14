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

extension PersonType: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .pmc: return "person_type_pmc".local()
        case .scav: return "person_type_scav".local()
        case .raider: return "person_type_raider".local()
        case .killa: return "person_type_killa".local()
        case .dealmaker: return "person_type_dealmaker".local()
        case .dealmakerFollower: return "person_type_dealmaker_guard".local()
        }
    }
}


extension CombatSimulationResult: Localizable {
    func local(short: Bool = false) -> String {
        switch self {
        case .win: return "simulation_result_win".local()
        case .loss: return "simulatoin_result_loss".local()
        case .tie: return "simulation_result_tie".local()
        }
    }
}

extension AimSetting: SelectionOption {
    var optionTitle: String { return local() }

    var optionSubtitle: String? {
        switch self {
        case .centerOfMass: return "aim_setting_center_mass_desc".local()
        case .headshotsOnly: return "aim_setting_headshots_desc".local()
        case .randomLegMeta: return "aim_setting_random_leg_desc".local()
        case .singleLegMeta: return "aim_setting_single_leg_desc".local()
        case .thoraxOnly: return "aim_setting_thorax_desc".local()
        }
    }
}

extension PersonType: SelectionOption {
    var optionTitle: String { return local() }

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

extension PersonType {
    var avatarImage: UIImage {
        switch self {
        case .pmc: return UIImage(named: "avatar_pmc")!
        case .scav: return UIImage(named: "avatar_scav")!
        case .raider, .dealmakerFollower: return UIImage(named: "avatar_raider")!
        case .killa: return UIImage(named: "avatar_killa")!
        case .dealmaker: return UIImage(named: "avatar_dealmaker")!
        }
    }
}
