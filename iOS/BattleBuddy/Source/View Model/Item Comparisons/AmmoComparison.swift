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
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var recommendedOptionsTitle: String?
    var secondaryRecommendedOptions: [Comparable]
    var secondaryRecommendedOptionsTitle: String? = nil
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .ammo)
    var preferRecommended: Bool = true

    init(_ initialAmmo: Ammo? = nil, allAmmo: [Ammo]) {
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

        for case let ammo as Ammo in itemsBeingCompared {
            penRange.updatedRangeIfNeeded(candidateValue: Float(ammo.penetration))
            damageRange.updatedRangeIfNeeded(candidateValue: Float(ammo.damage))
            armorDamageRange.updatedRangeIfNeeded(candidateValue: Float(ammo.armorDamage))
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
        case .penetration: return scaledValue(propertyValue: Float(ammo.penetration), range: range, traitCollection: traitCollection)
        case .damage: return scaledValue(propertyValue: Float(ammo.damage), range: range, traitCollection: traitCollection)
        case .armorDamage: return scaledValue(propertyValue: Float(ammo.armorDamage), range: range, traitCollection: traitCollection)
        case .fragChance: return scaledValue(propertyValue: Float(ammo.fragChance), range: range, traitCollection: traitCollection)
        case .muzzleVelocity: return scaledValue(propertyValue: Float(ammo.muzzleVelocity), range: range, traitCollection: traitCollection)
        default: fatalError()
        }
    }
}
