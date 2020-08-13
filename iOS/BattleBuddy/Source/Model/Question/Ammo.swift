//
//  Ammo.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

class Ammo: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let caliber: String
    var damage: Int
    var totalDamage: Int { get { return damage * projectileCount } }
    var armorDamage: Int
    var totalArmorDamage: Int
    var penetration: Int
    let fragChance: Float
    let muzzleVelocity: Int
    let tracer: Bool
    let subsonic: Bool
    let projectileCount: Int
    var fragmented: Bool = false

    init?(json: [String : Any]) {
        self.json = json
        self.type = .ammo

        guard BaseItemUtils.baseItemJsonValid(json),
            let rawCaliber = json["caliber"] as? String,
            let rawDamage = json["damage"] as? NSNumber,
            let rawArmorDamage = json["armorDamage"] as? NSNumber,
            let rawPenetration = json["penetration"] as? NSNumber,
            let fragmentation = json["fragmentation"] as? [String: Any],
            let rawFragChance = fragmentation["chance"] as? NSNumber,
            let rawMuzzleVel = json["velocity"] as? NSNumber,
            let rawSubsonic = json["subsonic"] as? NSNumber,
            let rawTracer = json["tracer"] as? NSNumber else {
                print("ERROR: Ammo missing required parameters in json: \(json)")
                return nil
        }

        caliber = rawCaliber
        damage = rawDamage.intValue
        armorDamage = rawArmorDamage.intValue
        penetration = rawPenetration.intValue
        fragChance = rawFragChance.floatValue
        muzzleVelocity = rawMuzzleVel.intValue
        subsonic = rawSubsonic.boolValue
        tracer = rawTracer.boolValue

        if let rawPellets = json["pellets"] as? NSNumber {
            projectileCount = rawPellets.intValue
        } else {
            projectileCount = 1
        }

        totalArmorDamage = armorDamage * projectileCount
    }
}

class SimulationAmmo: Ammo {
    override init?(json: [String : Any]) {
        super.init(json: json)
    }
}

// MARK: Ammo calculable
extension SimulationAmmo: CalculableAmmo {
    func copy(with zone: NSZone? = nil) -> Any {
        return SimulationAmmo(json: json)!
    }

    var resolvedAmmoName: String {
        get { return displayName }
    }

    var resolvedPenetration: Double {
        get { return Double(penetration) }
        set { penetration = Int(newValue) }
    }

    var resolvedDamage: Double {
        get { return Double(totalDamage) }
        set { damage = Int(newValue) }
    }

    var resolvedArmorDamage: Double {
        get { return Double(totalArmorDamage) }
        set { armorDamage = Int(newValue) }
    }

    var resolvedFragmentationChance: Double {
        return Double(fragChance)
    }

    var didFragment: Bool {
        get { return fragmented }
        set(newValue) { fragmented = newValue }
    }
}
