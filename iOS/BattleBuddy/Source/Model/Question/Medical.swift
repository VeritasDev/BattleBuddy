//
//  Medical.swift
//  BattleBuddy
//
//  Created by Mike on 7/17/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct Medical: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let maxResourceAmount: Int
    let totalUses: Int
    let useTime: Int
    let effectDuration: Int
    let removesBloodloss: Bool
    let removesContusion: Bool
    let removesFracture: Bool
    let removesPain: Bool
    let medicalItemType: MedicalItemType

    init?(json: [String: Any]) {
        self.json = json
        self.type = .medical

        guard BaseItemUtils.baseItemJsonValid(json),
            let rawType = json["type"] as? String,
            let resolvedType = MedicalItemType(rawValue: rawType),
            let rawMaxResource = json["resources"] as? NSNumber, let rawResourseRate = json["resourceRate"] as? NSNumber,
            let rawUseTime = json["useTime"] as? NSNumber,
            let rawEffects = json["effects"] as? [String: [String: NSNumber]] else {
                print("ERROR: Medical missing required parameters in json: \(json)")
                return nil
        }

        medicalItemType = resolvedType
        maxResourceAmount = rawMaxResource.intValue
        let resourceRate = rawResourseRate.intValue
        if maxResourceAmount != 0 && resourceRate != 0 {
            totalUses = maxResourceAmount / resourceRate
        } else if maxResourceAmount == 0 && resourceRate == 0 {
            totalUses = 1
        } else {
            totalUses = maxResourceAmount
        }

        useTime = rawUseTime.intValue
        removesBloodloss = rawEffects["bloodloss"]?["removes"]?.boolValue ?? false
        removesContusion = rawEffects["contusion"]?["removes"]?.boolValue ?? false
        removesFracture = rawEffects["fracture"]?["removes"]?.boolValue ?? false
        removesPain = rawEffects["pain"]?["removes"]?.boolValue ?? false
        effectDuration = rawEffects["pain"]?["duration"]?.intValue ?? 0
    }
}
