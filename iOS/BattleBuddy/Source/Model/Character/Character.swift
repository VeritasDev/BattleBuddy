//
//  Character.swift
//  BattleBuddy
//
//  Created by Veritas on 10/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

class Character {
    var json: [String: Any]
    var id: String
    var name: String
    var healthMap: [String: NSNumber]

    init?(json: [String : Any]) {
        self.json = json

        guard let rawId = json["_id"] as? String,
            let rawName = json["name"] as? String,
            let health = json["health"] as? [String: NSNumber] else {
                print("ERROR: Character missing required parameters in json: \(json)")
                return nil
        }

        id = rawId
        name = rawName
        healthMap = health
    }
}

class SimulationCharacter: Character {
    var firearm: SimulationFirearm?
    var armor: [SimulationArmor] = []
    var aim: AimSetting = .centerOfMass

    override init?(json: [String : Any]) {
        super.init(json: json)
    }

    func firearmSummary() -> String {
        if let firearm = firearm {
            if firearm.ammoConfig.isEmpty {
                return firearm.displayNameShort
            } else {
                let ammoConfig = ammoSummary()
                return firearm.displayNameShort.appending(", ").appending(ammoConfig)
            }
        } else {
            return "common_none".local()
        }
    }

    func ammoSummary() -> String {
        if let firearm = firearm, !firearm.ammoConfig.isEmpty {
            let separator = ", "
            return firearm.ammoConfig.compactMap{$0.displayNameShort}.joined(separator: separator)
        } else {
            return "common_none".local()
        }
    }

    func armorSummary() -> String {
        return armor.isEmpty ? "common_none".local() : armor.compactMap{$0.displayNameShort}.joined(separator: ", ")
    }
}

extension SimulationCharacter: CalculableCharacter {
    var resolvedArmor: [CalculableArmor] {
        get { return armor }
        set(newValue) { for (index, newArmor) in newValue.enumerated() { armor[index].currentDurability = Int(newArmor.resolvedCurrentDurability) } }
    }

    var resolvedFirearm: CalculableFirearm? { return firearm }
    var resolvedAimSetting: AimSetting { return aim }
    
    var resolvedHealthMap: [BodyZoneType : Double] {
        get {
            var convertedMap: [BodyZoneType : Double]  = [:]
            for zone in BodyZoneType.allCases {
                let zoneString = zone.getStringValue()
                if let healthNumber = healthMap[zoneString] {
                    convertedMap[zone] = healthNumber.doubleValue
                } else {
                    convertedMap[zone] = 0.0
                }
            }
            return convertedMap
        }
    }
}
