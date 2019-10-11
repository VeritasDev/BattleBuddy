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


extension AimSetting: SelectionOption {
    var optionTitle: String { return local() }

    var optionSubtitle: String {
        switch self {
        case .centerOfMass: return "aim_setting_center_mass_desc".local()
        case .headshotsOnly: return "aim_setting_headshots_desc".local()
        case .randomLegMeta: return "aim_setting_random_leg_desc".local()
        case .singleLegMeta: return "aim_setting_single_leg_desc".local()
        case .thoraxOnly: return "aim_setting_thorax_desc".local()
        }
    }


}
