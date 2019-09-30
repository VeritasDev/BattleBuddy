//
//  ModEnums.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum ModType: String, Localizable {
    case generic = "modification"
    case barrel = "modificationBarrel"
    case bipod  = "modificationBipod"
    case charge = "modificationCharge"
    case device = "modificationDevice"
    case foregrip = "modificationForegrip"
    case gasBlock = "modificationGasblock"
    case goggles = "modificationGoggles"
    case handgaurd = "modificationHandguard"
    case launcher = "modificationLauncher"
    case mount = "modificationMount"
    case muzzle = "modificationMuzzle"
    case pistolGrip = "modificationPistolgrip"
    case receiver = "modificationReceiver"
    case sight = "modificationSight"
    case sightSpecial = "modificationSightSpecial"
    case stock = "modificationStock"

    func local(short: Bool = false) -> String {
        return "mod_" + self.rawValue
    }
}

