//
//  MeleeWeaponComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

private struct ComparedMeleePropertiesSummary {
    var stabDmg: (min: Float, max: Float) = (MAXFLOAT, 0)
    var stabRate: (min: Float, max: Float) = (MAXFLOAT, 0)
    var stabRange: (min: Float, max: Float) = (MAXFLOAT, 0)
    var slashDmg: (min: Float, max: Float) = (MAXFLOAT, 0)
    var slashRate: (min: Float, max: Float) = (MAXFLOAT, 0)
    var slashRange: (min: Float, max: Float) = (MAXFLOAT, 0)
}

struct MeleeWeaponComparison: ItemComparison {
    var propertyType: ComparablePropertyType = .melee
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var recommendedOptionsTitle: String?
    var secondaryRecommendedOptions: [Comparable] = []
    var secondaryRecommendedOptionsTitle: String? = nil
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .melee)
    var preferRecommended: Bool = false
    private var comparedItemsSummary: ComparedMeleePropertiesSummary?

    init(_ allMelee: [MeleeWeapon]) {
        itemsBeingCompared = allMelee
        recommendedOptions = allMelee
        possibleOptions = []

        var summary = ComparedMeleePropertiesSummary()

        for case let melee as MeleeWeapon in itemsBeingCompared {
            let candidateStabDmg = Float(melee.stabDamage)
            let candidateStabRate = Float(melee.stabRate)
            let candidateStabRange = Float(melee.stabRange)
            let candidateSlashDmg = Float(melee.slashDamage)
            let candidateSlashRate = Float(melee.slashRate)
            let candidateSlashRange = Float(melee.slashRange)

            summary.stabDmg = (min(candidateStabDmg, summary.stabDmg.min), max(candidateStabDmg, summary.stabDmg.max))
            summary.stabRate = (min(candidateStabRate, summary.stabRate.min), max(candidateStabRate, summary.stabRate.max))
            summary.stabRange = (min(candidateStabRange, summary.stabRange.min), max(candidateStabRange, summary.stabRange.max))

            summary.slashDmg = (min(candidateSlashDmg, summary.slashDmg.min), max(candidateSlashDmg, summary.slashDmg.max))
            summary.slashRate = (min(candidateSlashRate, summary.slashRate.min), max(candidateSlashRate, summary.slashRate.max))
            summary.slashRange = (min(candidateSlashRate, summary.slashRange.min), max(candidateSlashRange, summary.slashRange.max))
        }

        comparedItemsSummary = summary
    }

    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float {
        guard let melee = item as? MeleeWeapon else { fatalError() }
        let range = getComparedItemsSummaryMap()[property]!

        switch property {
        case .stabDamage: return scaledValue(propertyValue: Float(melee.stabDamage), range: range, traitCollection: traitCollection)
        case .stabRate: return scaledValue(propertyValue: Float(melee.stabRate), range: range, traitCollection: traitCollection)
        case .stabRange: return scaledValue(propertyValue: Float(melee.stabRange), range: range, traitCollection: traitCollection)
        case .slashDamage: return scaledValue(propertyValue: Float(melee.slashDamage), range: range, traitCollection: traitCollection)
        case .slashRate: return scaledValue(propertyValue: Float(melee.slashRate), range: range, traitCollection: traitCollection)
        case .slashRange: return scaledValue(propertyValue: Float(melee.slashRange), range: range, traitCollection: traitCollection)
        default: fatalError()
        }
    }

    func getComparedItemsSummaryMap() -> [ComparableProperty: PropertyRange] {
        var stabDamageRange = PropertyRange()
        var stabRateRange = PropertyRange()
        var stabRangeRange = PropertyRange()
        var slashDamageRange = PropertyRange()
        var slashRateRange = PropertyRange()
        var slashRangeRange = PropertyRange()

        for case let melee as MeleeWeapon in itemsBeingCompared {
            stabDamageRange.updatedRangeIfNeeded(candidateValue: Float(melee.stabDamage))
            stabRateRange.updatedRangeIfNeeded(candidateValue: Float(melee.stabRate))
            stabRangeRange.updatedRangeIfNeeded(candidateValue: Float(melee.stabRange))
            slashDamageRange.updatedRangeIfNeeded(candidateValue: Float(melee.slashDamage))
            slashRateRange.updatedRangeIfNeeded(candidateValue: Float(melee.slashRate))
            slashRangeRange.updatedRangeIfNeeded(candidateValue: Float(melee.slashRange))
        }

        return [
            .stabDamage: stabDamageRange,
            .stabRate: stabRateRange,
            .stabRange: stabRangeRange,
            .slashDamage: slashDamageRange,
            .slashRate: slashRateRange,
            .slashRange: slashRangeRange
        ]
    }
}
