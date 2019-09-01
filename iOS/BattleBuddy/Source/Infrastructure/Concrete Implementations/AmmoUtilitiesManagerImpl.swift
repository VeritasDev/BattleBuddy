//
//  AmmoUtilitiesManagerImpl.swift
//  BattleBuddy
//
//  Created by Mike on 8/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class AmmoUtilitiesManagerImpl: AmmoUtilitiesManager {
    func caliberDisplayName(_ caliber: String) -> String {
        let metadataManager = DependencyManager.shared.metadataManager
        guard let metadata = metadataManager.getGlobalMetadata() else { return caliber }
        for ammo in metadata.ammoMetadata { if ammo.caliber == caliber { return ammo.displayName } }
        return caliber
    }
}
