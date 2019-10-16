//
//  Character.swift
//  BattleBuddy
//
//  Created by Veritas on 10/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

struct Character {
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

extension Character: CharacterConfig {
    var resolvedIdentifier: String { get { return id } }
    var resolvedCharacterName: String { get { return name } }
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
