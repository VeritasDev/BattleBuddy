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
    let firearm: Firearm
    var firearmBuild: FirearmBuild?

    init(_ firearm: Firearm) {
        self.firearm = firearm
    }

    func loadBuildData(handler: @escaping (_: [Modification]) -> Void) {
        dbManager.getCompatibleItemsForFirearm(firearm) { (config) in
            self.firearmBuild = FirearmBuild(config: config, preset: .none)
        }
    }
}
