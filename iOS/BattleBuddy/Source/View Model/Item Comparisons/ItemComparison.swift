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
    var allItems: [Comparable] { get }
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
    func scaledValue(propertyValue: Float, range: PropertyRange) -> Float {
        let minAllowed: Float = 0.01
        let maxAllowed: Float = 1.0
        let scaledValue = scaleBetween(unscaledNum: propertyValue, minAllowed: minAllowed, maxAllowed: maxAllowed, min: range.minValue, max: range.maxValue)
        return scaledValue
    }

    func scaledValue(boolValue isTrue: Bool, range: PropertyRange) -> Float {
        return scaledValue(propertyValue: isTrue ? range.maxValue : range.minValue, range: range)
    }
}
