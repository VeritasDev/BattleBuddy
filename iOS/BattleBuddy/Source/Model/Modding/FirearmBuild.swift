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
    let buildConfig: FirearmBuildConfig
    let preset: FirearmBuildPreset

    init(config: FirearmBuildConfig, preset: FirearmBuildPreset) {
        self.buildConfig = config
        self.preset = preset
    }
}

struct FirearmBuildConfig {
    let firearm: Firearm
    let allCompatibleMods: [Modification]
}
