//
//  ChestRig.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//
//
import Foundation
import BallisticsEngine

class ChestRig: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let armorConfig: Armor?

    init?(json: [String: Any]) {
        self.json = json
        self.type = .rig

        guard BaseItemUtils.baseItemJsonValid(json) else {
            print("ERROR: ChestRig missing required parameters in json: \(json)")
            return nil
        }

        var updatedJson = json
        updatedJson["type"] = "body"
        self.armorConfig = Armor(json: updatedJson)
    }
}
