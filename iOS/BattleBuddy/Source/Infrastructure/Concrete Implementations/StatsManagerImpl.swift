//
//  GlobalStats.swift
//  BattleBuddy
//
//  Created by Mike on 7/30/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class StatsManagerImpl: StatsManager {
//    lazy var dbManager: RealmManager = DependencyManager.shared.databaseManager
    var ammoStats: AmmoStats?

    func preCacheAllStats() {
        preCacheAmmoStats()
    }

    func preCacheAmmoStats() {
        var caliberDamageMap: [String : (maxPen: Ammo, maxDamage: Ammo, maxArmorDamage: Ammo)] = [:]

        let allAmmo: [Ammo] = []//dbManager.getAmmo()
        for ammo in allAmmo {
            if var statsForCaliber = caliberDamageMap[ammo.caliber] {
                if ammo.penetration > statsForCaliber.maxPen.penetration {
                    statsForCaliber.maxPen = ammo
                }

                if ammo.damage > statsForCaliber.maxDamage.damage {
                    statsForCaliber.maxDamage = ammo
                }

                if ammo.armorDamage > statsForCaliber.maxArmorDamage.armorDamage {
                    statsForCaliber.maxArmorDamage = ammo
                }

                caliberDamageMap[ammo.caliber] = statsForCaliber
            } else {
                caliberDamageMap[ammo.caliber] = (maxPen: ammo, maxDamage: ammo, maxArmorDamage: ammo)
            }
        }

        self.ammoStats = AmmoStats(caliberDamageMap: caliberDamageMap)
    }

    func overallAmmoStats() -> AmmoStats {
        return ammoStats!
    }
}
