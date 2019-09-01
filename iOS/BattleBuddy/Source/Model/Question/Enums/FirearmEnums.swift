//
//  FirearmEnums.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum FirearmType: String, CaseIterable, Localizable {
    case assaultRifle = "assaultRifle"
    case designatedMarksmanRifle = "marksmanRifle"
    case machinegun = "machinegun"
    case submachineGun = "smg"
    case sniperRifle = "sniperRifle"
    case assaultCarbine = "assaultCarbine"
    case pistol = "pistol"
    case shotgun = "shotgun"

    func local(short: Bool = false) -> String {
        switch self {
        case .assaultRifle: return Localized("assault_rifle")
        case .machinegun: return Localized("machine_gun")
        case .designatedMarksmanRifle: return Localized("designated_marksman_rifle")
        case .submachineGun: return Localized("sub_machine_gun")
        case .assaultCarbine: return Localized("assault_carbine")
        case .sniperRifle: return Localized("sniper_rifle")
        case .pistol: return Localized("pistol")
        case .shotgun: return Localized("shotgun")
        }
    }
}

enum FireModeRestriction {
    case none
    case semiAutoOnly
    case fullAutoCapable
}

enum ActionRestriction {
    case none
    case pumpOnly
    case boltOnly
    case manualOnly
    case auto
}

enum ActionType: Localizable {
    case other
    case pump
    case bolt

    init(value: String) {
        switch value {
        case "pump": self = .pump
        case "bolt": self = .bolt
        default: self = .other
        }
    }

    func local(short: Bool = false) -> String {
        switch self {
        case .pump: return short ? "action_type_pump_short".local() : "action_type_pump".local()
        case .bolt: return short ? "action_type_bolt_short".local() : "action_type_bolt".local()
        default: fatalError()
        }
    }

    func isManualAction() -> Bool {
        switch self {
        case .pump, .bolt: return true
        default: return false
        }
    }
}
