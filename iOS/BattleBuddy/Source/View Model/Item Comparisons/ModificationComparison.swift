//
//  ModificationComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

private struct ComparedModificationPropertiesSummary {
//    var fuseTime: (min: Float, max: Float) = (0, MAXFLOAT)
//    var fragCount: (min: Float, max: Float) = (0, MAXFLOAT)
//    var explosionRadiusMin: (min: Float, max: Float) = (0, MAXFLOAT)
//    var explosionRadiusMax: (min: Float, max: Float) = (0, MAXFLOAT)
}

struct ModificationComparison: ItemComparison {
    var propertyType: ComparablePropertyType = .throwable
    var allItems: [Comparable]
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var recommendedOptionsTitle: String?
    var secondaryRecommendedOptions: [Comparable] = []
    var secondaryRecommendedOptionsTitle: String? = nil
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .throwable)
    var preferRecommended: Bool = false
    private var comparedItemsSummary: ComparedModificationPropertiesSummary?

    init(_ allMods: [Modification]) {
        allItems = allMods
        itemsBeingCompared = allMods
        recommendedOptions = allMods
        possibleOptions = []
    }

    // TODO: Implement
    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float {
//        guard let throwable = item as? Throwable else { fatalError() }
//        let range = getComparedItemsSummaryMap()[property]!
//
//        switch property {
//        default: fatalError()
//        }
        return 1.0
    }

    func getComparedItemsSummaryMap() -> [ComparableProperty: PropertyRange] {
//
//        for case let mod as Modification in allItems {
//        }

        return [:]
    }
}
