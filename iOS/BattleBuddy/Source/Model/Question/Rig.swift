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

struct InventoryGrid {
    let width: Int
    let height: Int

    init?(json: [String: Any]) {
        guard let rawWidth = json["width"] as? NSNumber,
            let rawHeight = json["height"] as? NSNumber else {
                return nil
        }

        width = rawWidth.intValue
        height = rawHeight.intValue
    }
}

class ChestRig: Armor {
    let grids: [InventoryGrid]
    let totalCapacity: Int
    let oneByOneSlots: Int
    let oneByTwoSlots: Int
    let oneByThreeSlots: Int
    let twoByTwoSlots: Int
    var isArmored: Bool = false

    override init?(type: ItemType = .rig, json: [String : Any]) {
        guard BaseItemUtils.baseItemJsonValid(json),
            let rawGrids = json["grids"] as? [[String: Any]] else {
            print("ERROR: ChestRig missing required parameters in json: \(json)")
            return nil
        }

        grids = rawGrids.compactMap { InventoryGrid(json: $0) }
        totalCapacity = grids.reduce(0) { $0 + ($1.width * $1.height) }

        var totalOneByOneSlots: Int = 0
        var totalOneByTwoSlots: Int = 0
        var totalOneByThreeSlots: Int = 0
        var totalTwoByTwoSlots: Int = 0

        for grid in grids {
            switch(grid.width, grid.height) {
            case (1, 1): totalOneByOneSlots += 1
            case (1, 2): totalOneByTwoSlots += 1
            case (1, 3): totalOneByThreeSlots += 1
            case (2, 2): totalTwoByTwoSlots += 1
            default: break
            }
        }

        oneByOneSlots = totalOneByOneSlots
        oneByTwoSlots = totalOneByTwoSlots
        oneByThreeSlots = totalOneByThreeSlots
        twoByTwoSlots = totalTwoByTwoSlots

        var updatedJson = json
        updatedJson["type"] = "body"
        super.init(type: type, json: updatedJson)

        if armorClass != ArmorClass.none {
            isArmored = true
        }
    }
}
