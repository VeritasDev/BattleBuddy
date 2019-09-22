//
//  Armored.swift
//  BattleBuddy
//
//  Created by Veritas on 9/19/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

protocol Armored {
    var maxDurability: Int { get set }
    var currentDurability: Int { get set }
    var material: ArmorMaterial { get }
    var armorType: ArmorType { get }
    var armorClass: ArmorClass { get }
    var richochetParams: RichochetParams { get }
    var penalties: Penalties { get }
    var armorZoneConfig: ArmorZonesConfig { get }
}
