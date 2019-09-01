//
//  ThrowableComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

private struct ComparedThrowablePropertiesSummary {
    var fuseTime: (min: Float, max: Float) = (0, MAXFLOAT)
    var fragCount: (min: Float, max: Float) = (0, MAXFLOAT)
    var explosionRadiusMin: (min: Float, max: Float) = (0, MAXFLOAT)
    var explosionRadiusMax: (min: Float, max: Float) = (0, MAXFLOAT)
}

struct ThrowableComparison: ItemComparison {
    var propertyType: ComparablePropertyType = .throwable
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var recommendedOptionsTitle: String?
    var secondaryRecommendedOptions: [Comparable] = []
    var secondaryRecommendedOptionsTitle: String? = nil
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .throwable)
    var preferRecommended: Bool = false
    private var comparedItemsSummary: ComparedThrowablePropertiesSummary?

    init(_ allThrowables: [Throwable]) {
        itemsBeingCompared = allThrowables
        recommendedOptions = allThrowables
        possibleOptions = []
    }

    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float {
        guard let throwable = item as? Throwable else { fatalError() }
        let range = getComparedItemsSummaryMap()[property]!

        switch property {
        case .fuseTime: return scaledValue(propertyValue: Float(throwable.fuseTime), range: range, traitCollection: traitCollection)
        case .fragmentationCount: return scaledValue(propertyValue: Float(throwable.fragmentationCount), range: range, traitCollection: traitCollection)
        case .explosionRadiusMin: return scaledValue(propertyValue: Float(throwable.explosionRadiusMin), range: range, traitCollection: traitCollection)
        case .explosionRadiusMax: return scaledValue(propertyValue: Float(throwable.explosionRadiusMax), range: range, traitCollection: traitCollection)
        default: fatalError()
        }
    }

    func getComparedItemsSummaryMap() -> [ComparableProperty: PropertyRange] {
        var fuseTimeRange = PropertyRange()
        var fragCountRange = PropertyRange()
        var radiusRange = PropertyRange()

        for case let throwable as Throwable in itemsBeingCompared {
            fuseTimeRange.updatedRangeIfNeeded(candidateValue: Float(throwable.fuseTime))
            fragCountRange.updatedRangeIfNeeded(candidateValue: Float(throwable.fragmentationCount))
            radiusRange.updatedRangeIfNeeded(candidateValue: Float(throwable.explosionRadiusMin))
            radiusRange.updatedRangeIfNeeded(candidateValue: Float(throwable.explosionRadiusMax))
        }

        return [
            .fuseTime: fuseTimeRange,
            .fragmentationCount: fragCountRange,
            .explosionRadiusMin: radiusRange,
            .explosionRadiusMax: radiusRange
        ]
    }
}
