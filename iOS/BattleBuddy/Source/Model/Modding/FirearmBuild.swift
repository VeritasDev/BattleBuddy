//
//  FirearmBuild.swift
//  BattleBuddy
//
//  Created by Mike on 7/10/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum FirearmBuildPreset {
    case none
    case ergo
    case recoil
    case random
}

struct FirearmBuild {
    let databaseManager = DependencyManagerImpl.shared.databaseManager()
    let firearm: Firearm
    let preset: FirearmBuildPreset

    init(firearm: Firearm, preset: FirearmBuildPreset) {
        self.firearm = firearm
        self.preset = preset
    }
}
