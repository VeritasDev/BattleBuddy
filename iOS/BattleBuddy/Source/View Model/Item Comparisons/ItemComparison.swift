//
//  ItemComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

enum ComparablePropertyType {
    case firearm
    case ammo
    case armor
    case medical
    case throwable
    case melee
}

protocol ItemComparison {
    var propertyType: ComparablePropertyType { get }
    var itemsBeingCompared: [Comparable] { get set }
    var possibleOptions: [Comparable] { get set }
    var recommendedOptions: [Comparable] { get set }
    var recommendedOptionsTitle: String? { get set }
    var secondaryRecommendedOptions: [Comparable] { get set }
    var secondaryRecommendedOptionsTitle: String? { get set }
    var propertyOptions: [ComparableProperty] { get }
    var preferRecommended: Bool { get set }
    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float
    func getComparedItemsSummaryMap() -> [ComparableProperty: PropertyRange]
}

struct PropertyRange {
    var minValue: Float = MAXFLOAT
    var maxValue: Float = -MAXFLOAT

    mutating func updatedRangeIfNeeded(candidateValue: Float) {
        minValue = min(candidateValue, minValue)
        maxValue = max(candidateValue, maxValue)
    }
}

extension ItemComparison {
    func scaledValue(propertyValue: Float, range: PropertyRange, traitCollection: UITraitCollection) -> Float {
        let isCompact = traitCollection.horizontalSizeClass == .compact
        let minAllowed: Float = isCompact ? 0.35 : 0.25
        let maxAllowed: Float = isCompact ? 0.95 : 0.90
        return scaleBetween(unscaledNum: propertyValue, minAllowed: minAllowed, maxAllowed: maxAllowed, min: range.minValue, max: range.maxValue)
    }

    func scaledValue(boolValue isTrue: Bool, range: PropertyRange, traitCollection: UITraitCollection) -> Float {
        return scaledValue(propertyValue: isTrue ? range.maxValue : range.minValue, range: range, traitCollection: traitCollection)
    }
}
