//
//  Firearm.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct Firearm: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let firearmType: FirearmType
    let caliber: String
    let action: ActionType
    let semiAuto: Bool
    let burst: Bool
    let fullAuto: Bool
    let verticalRecoil: Int
    let horizontalRecoil: Int
    let fireRate: Int
    let effectiveDistance: Int
    let foldableOrRetractable: Bool

    init?(json: [String : Any]) {
        self.json = json
        self.type = .firearm

        guard BaseItemUtils.baseItemJsonValid(json),
            let rawCaliber = json["caliber"] as? String,
            let rawFirearmType = json["class"] as? String,
            let type = FirearmType(rawValue: rawFirearmType),
            let rawAction = json["action"] as? String,
            let rawFireModes: [String] = json["modes"] as? [String],
            let boxedVerticalRecoil: NSNumber = json["recoilVertical"] as? NSNumber,
            let boxedHorizontalRecoil: NSNumber = json["recoilHorizontal"] as? NSNumber,
            let boxedFoldRetractable: NSNumber = json["foldRectractable"] as? NSNumber,
            let boxedFireRate: NSNumber = json["rof"] as? NSNumber,
            let boxedEffectiveDistance: NSNumber = json["effectiveDist"] as? NSNumber else {
                print("ERROR: Firearm missing required parameters in json: \(json)")
                return nil
        }

        caliber = rawCaliber
        firearmType = type
        action = ActionType(value: rawAction)
        semiAuto = rawFireModes.contains("single")
        burst = rawFireModes.contains("burst")
        fullAuto = rawFireModes.contains("full")
        verticalRecoil = boxedVerticalRecoil.intValue
        horizontalRecoil = boxedHorizontalRecoil.intValue
        foldableOrRetractable = boxedFoldRetractable.boolValue
        fireRate = boxedFireRate.intValue
        effectiveDistance = boxedEffectiveDistance.intValue
    }

    func fireModesDisplayString() -> String {
        var modes: [String] = []
        if semiAuto { modes.append("fire_mode_semi_short".local()) }
        if burst { modes.append("fire_mode_burst_short".local()) }
        if fullAuto { modes.append("fire_mode_auto_short".local()) }
        return modes.joined(separator: ", ")
    }
}
