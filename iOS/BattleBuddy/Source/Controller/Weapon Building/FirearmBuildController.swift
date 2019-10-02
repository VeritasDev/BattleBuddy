//
//  FirearmBuildController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class FirearmBuildController {
    lazy var dbManager = DependencyManagerImpl.shared.databaseManager()
    let buildConfig: FirearmBuildConfig

    init(_ config: FirearmBuildConfig) {
        buildConfig = config
    }

    func attachMod(_ mod: Modification, toSlot slot: Slot) {
        guard slot.compatibleItemIds.contains(mod.id), !slot.conflictingItemIds.contains(mod.id) else { fatalError() }
    }
}
