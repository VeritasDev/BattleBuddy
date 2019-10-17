//
//  Armor.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import BallisticsEngine

class Armor: BaseItem, Armored {
    let json: [String : Any]
    let type: ItemType
    var maxDurability: Int
    var currentDurability: Int
    let material: ArmorMaterial
    let armorType: ArmorType
    let armorClass: ArmorClass
    var richochetParams: RichochetParams { get { return RichochetParams(x: richochetX, y: richochetY, z: richochetZ) } }
    var penalties: Penalties { get { return Penalties(ergonomics: ergoPenalty, turnSpeed: turnSpeedPenalty, movementSpeed:  movementSpeedPenalty, hearing: hearingPenalty) } }
    var armorZoneConfig: ArmorZonesConfig { get { return ArmorZonesConfig(topHead: protectsTopHead, eyes: protectsEyes, jaws: protectsJaws, ears: protectsEars, nape: protectsNape, chest: protectsChest, stomach: protectsStomach, leftArm: protectsLeftArm, rightArm: protectsRightArm, leftLeg: protectsLeftLeg, rightLeg: protectsRightLeg) } }

    fileprivate var bluntThroughput: Float
    fileprivate var ergoPenalty: Int
    fileprivate var turnSpeedPenalty: Int
    fileprivate var movementSpeedPenalty: Int
    fileprivate var hearingPenalty: HearingPenalty
    fileprivate var richochetX: Float
    fileprivate var richochetY: Float
    fileprivate var richochetZ: Float
    fileprivate var protectsTopHead: Bool
    fileprivate var protectsEyes: Bool
    fileprivate var protectsJaws: Bool
    fileprivate var protectsEars: Bool
    fileprivate var protectsNape: Bool
    fileprivate var protectsChest: Bool
    fileprivate var protectsStomach: Bool
    fileprivate var protectsLeftArm: Bool
    fileprivate var protectsRightArm: Bool
    fileprivate var protectsLeftLeg: Bool
    fileprivate var protectsRightLeg: Bool

    init?(json: [String: Any]) {
        self.json = json
        self.type = .armor

        guard BaseItemUtils.baseItemJsonValid(json),
            let rawType = json["type"] as? String,
            let resolvedType = ArmorType(rawValue: rawType),
            let armorProperties = json["armor"] as? [String: Any],
            let rawMaterial = armorProperties["material"] as? [String: Any],
            let rawMaterialName = rawMaterial["name"] as? String,
            let resolvedMaterial = ArmorMaterial(rawValue: rawMaterialName),
            let rawDurability = armorProperties["durability"] as? NSNumber,
            let rawClass = armorProperties["class"] as? NSNumber,
            let resolvedArmorClass = ArmorClass(rawValue: rawClass.intValue),
            let rawZones = armorProperties["zones"] as? [String],
            let rawBluntTp = armorProperties["bluntThroughput"] as? NSNumber,
            let penalties = json["penalties"] as? [String: Any] else {
                print("ERROR: Armor missing required parameters in json: \(json)")
                return nil
        }

        armorType = resolvedType
        material = resolvedMaterial
        armorClass = resolvedArmorClass
        maxDurability = rawDurability.intValue
        currentDurability = maxDurability
        protectsTopHead = rawZones.contains("top")
        protectsEyes = rawZones.contains("eyes")
        protectsJaws = rawZones.contains("jaws")
        protectsEars = rawZones.contains("ears")
        protectsNape = rawZones.contains("nape")
        protectsChest = rawZones.contains("chest")
        protectsStomach = rawZones.contains("stomach")
        protectsLeftArm = rawZones.contains("leftarm")
        protectsRightArm = rawZones.contains("rightarm")
        protectsLeftLeg = rawZones.contains("leftleg")
        protectsRightLeg = rawZones.contains("rightleg")
        bluntThroughput = rawBluntTp.floatValue

        if let speedPen = penalties["speed"] as? NSNumber {
            movementSpeedPenalty = speedPen.intValue
        } else {
            movementSpeedPenalty = 0
        }

        if let ergoPen = penalties["ergonomics"] as? NSNumber {
            ergoPenalty = ergoPen.intValue
        } else {
            ergoPenalty = 0
        }

        if let mousePen = penalties["mouse"] as? NSNumber {
            turnSpeedPenalty = mousePen.intValue
        } else {
            turnSpeedPenalty = 0
        }

        if let hearingPen = penalties["deafness"] as? String {
            hearingPenalty = HearingPenalty(rawValue: hearingPen) ?? HearingPenalty.none
        } else {
            hearingPenalty = HearingPenalty.none
        }

        if let ricochet: [String: NSNumber] = json["ricochet"] as? [String: NSNumber] {
            richochetX = ricochet["x"]?.floatValue ?? 0
            richochetY = ricochet["y"]?.floatValue ?? 0
            richochetZ = ricochet["z"]?.floatValue ?? 0
        } else {
            richochetX = 0
            richochetY = 0
            richochetZ = 0
        }
    }

    func localizedArmorZonesDisplayString() -> String {
        var components: [String] = []

        if protectsTopHead { components.append("armor_zone_top".local()) }
        if protectsEyes { components.append("armor_zone_eyes".local()) }
        if protectsJaws { components.append("armor_zone_jaws".local()) }
        if protectsEars { components.append("armor_zone_ears".local()) }
        if protectsNape { components.append("armor_zone_nape".local()) }
        if protectsChest { components.append("armor_zone_chest".local()) }
        if protectsStomach { components.append("armor_zone_stomach".local()) }
        if protectsLeftArm { components.append("armor_zone_left_arm".local()) }
        if protectsRightArm { components.append("armor_zone_right_arm".local()) }
        if protectsLeftLeg { components.append("armor_zone_left_leg".local()) }
        if protectsRightLeg { components.append("armor_zone_right_leg".local()) }

        return components.joined(separator: ", ")
    }
}

class SimulationArmor: Armor {
    override init?(json: [String: Any]) {
        super.init(json: json)
    }
}

// MARK: Calculable Armor
extension SimulationArmor: CalculableArmor {
    var resolvedArmorName: String { get { return displayName } }
    var resolvedArmorClass: Int { get { return armorClass.rawValue } }
    var resolvedCurrentDurability: Double {
        get { return Double(currentDurability) }
        set { currentDurability = Int(newValue) }
    }
    var resolvedMaxDurability: Double {
        get { return Double(maxDurability) }
        set { maxDurability = Int(newValue) }
    }
    var resolvedDestructibility: Double { get {  return Double(material.destructibility()) } }
    var resolvedBluntThroughput: Double { get {  return Double(bluntThroughput) } }
    var resolvedProtectionZones: [BallisticsEngine.BodyZoneType] {
        var zones: [BallisticsEngine.BodyZoneType] = []

        if protectsTopHead { zones.append(.head) }
        if protectsEyes { zones.append(.head) }
        if protectsJaws { zones.append(.head) }
        if protectsEars { zones.append(.head) }
        if protectsNape { zones.append(.head) }
        if protectsChest { zones.append(.thorax) }
        if protectsStomach { zones.append(.stomach) }
        if protectsLeftArm { zones.append(.leftArm) }
        if protectsRightArm { zones.append(.rightArm) }
        if protectsLeftLeg { zones.append(.leftLeg) }
        if protectsRightLeg { zones.append(.rightLeg) }

        return zones
    }
}
