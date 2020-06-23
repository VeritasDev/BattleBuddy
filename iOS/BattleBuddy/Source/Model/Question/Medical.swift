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
    let removesBlackout: Bool
    let medicalItemType: MedicalItemType

    init?(json: [String: Any]) {
        self.json = json
        self.type = .medical

        guard BaseItemUtils.baseItemJsonValid(json),
            let rawType = json["type"] as? String,
            let resolvedType = MedicalItemType(rawValue: rawType),
            let rawMaxResource = json["resources"] as? NSNumber,
            let rawResourseRate = json["resourceRate"] as? NSNumber,
            let rawUseTime = json["useTime"] as? NSNumber,
            let rawEffects = json["effects"] as? [String: Any] else {
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

        if let blackoutEffets = rawEffects["destroyedPart"] as? [String: Any],
            let removes = blackoutEffets["removes"] as? NSNumber {
            removesBlackout = removes.boolValue
        } else {
            removesBlackout = false
        }

        if let fractureEffets = rawEffects["fracture"] as? [String: Any],
            let removes = fractureEffets["removes"] as? NSNumber {
            removesFracture = removes.boolValue
        } else {
            removesFracture = false
        }

        if let contusionEffets = rawEffects["contusion"] as? [String: Any],
            let removes = contusionEffets["removes"] as? NSNumber {
            removesContusion = removes.boolValue
        } else {
            removesContusion = false
        }

        if let painEffets = rawEffects["pain"] as? [String: Any],
            let removes = painEffets["removes"] as? NSNumber,
            let duration = painEffets["duration"] as? NSNumber {
            removesPain = removes.boolValue
            effectDuration = duration.intValue
        } else {
            removesPain = false
            effectDuration = 0
        }

        if let bloodlossEffets = rawEffects["bloodloss"] as? [String: Any],
            let removes = bloodlossEffets["removes"] as? NSNumber {
            removesBloodloss = removes.boolValue
        } else {
            removesBloodloss = false
        }
    }
}
