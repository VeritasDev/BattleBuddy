//
//  AmmoComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct AmmoComparison: ItemComparison {
    var propertyType: ComparablePropertyType = .ammo
    var allItems: [Comparable]
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var recommendedOptionsTitle: String?
    var secondaryRecommendedOptions: [Comparable]
    var secondaryRecommendedOptionsTitle: String? = nil
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .ammo)
    var preferRecommended: Bool = true

    init(_ initialAmmo: Ammo? = nil, allAmmo: [Ammo]) {
        allItems = allAmmo
        if let ammo = initialAmmo {
            possibleOptions = allAmmo

            recommendedOptions = AmmoComparison.generateRecommendedOptions(ammo, allAmmo: allAmmo)
            recommendedOptionsTitle = ammo.caliber
            itemsBeingCompared = recommendedOptions
            secondaryRecommendedOptions = []

            for recommended in recommendedOptions { possibleOptions.removeAll{ $0.identifier == recommended.identifier } }
        } else {
            possibleOptions = allAmmo
            itemsBeingCompared = []
            recommendedOptions = []
            secondaryRecommendedOptions = []
        }
    }

    private static func generateRecommendedOptions(_ initialAmmo: Ammo, allAmmo: [Ammo]) -> [Ammo] {
        let ammoMatchingCaliber = allAmmo.filter {
            if initialAmmo.caliber != $0.caliber { return false }
            return true
        }

        return ammoMatchingCaliber
    }

    func getComparedItemsSummaryMap() -> [ComparableProperty : PropertyRange] {
        var penRange = PropertyRange()
        var damageRange = PropertyRange()
        var armorDamageRange = PropertyRange()
        var fragChanceRange = PropertyRange()
        var muzzleVelRange = PropertyRange()

        for case let ammo as Ammo in allItems {
            penRange.updatedRangeIfNeeded(candidateValue: Float(ammo.penetration))
            damageRange.updatedRangeIfNeeded(candidateValue: Float(ammo.totalDamage))
            armorDamageRange.updatedRangeIfNeeded(candidateValue: Float(ammo.totalArmorDamage))
            fragChanceRange.updatedRangeIfNeeded(candidateValue: Float(ammo.fragChance))
            muzzleVelRange.updatedRangeIfNeeded(candidateValue: Float(ammo.muzzleVelocity))
        }

        return [
            .penetration: penRange,
            .damage: damageRange,
            .armorDamage: armorDamageRange,
            .fragChance: fragChanceRange,
            .muzzleVelocity: muzzleVelRange
        ]
    }

    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float {
        guard let ammo = item as? Ammo else { fatalError() }
        let range = getComparedItemsSummaryMap()[property]!

        switch property {
        case .penetration: return scaledValue(propertyValue: Float(ammo.penetration), range: range)
        case .damage: return scaledValue(propertyValue: Float(ammo.totalDamage), range: range)
        case .armorDamage: return scaledValue(propertyValue: Float(ammo.totalArmorDamage), range: range)
        case .fragChance: return scaledValue(propertyValue: Float(ammo.fragChance), range: range)
        case .muzzleVelocity: return scaledValue(propertyValue: Float(ammo.muzzleVelocity), range: range)
        default: fatalError()
        }
    }
}
