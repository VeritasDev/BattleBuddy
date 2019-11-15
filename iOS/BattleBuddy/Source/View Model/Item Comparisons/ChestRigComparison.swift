//
//  ChestRigComparison.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct ChestRigComparison: ItemComparison {
    var propertyType: ComparablePropertyType = .chestRig
    var allItems: [Comparable]
    var itemsBeingCompared: [Comparable]
    var possibleOptions: [Comparable]
    var recommendedOptions: [Comparable]
    var secondaryRecommendedOptions: [Comparable] = []
    var secondaryRecommendedOptionsTitle: String? = nil
    var propertyOptions: [ComparableProperty] = ComparableProperty.propertiesForType(type: .chestRig)
    var recommendedOptionsTitle: String?
    var preferRecommended: Bool = true

    init(allChestRigs: [ChestRig]) {
        allItems = allChestRigs
        itemsBeingCompared = allChestRigs
        recommendedOptions = allChestRigs
        possibleOptions = []
    }

    func getComparedItemsSummaryMap() -> [ComparableProperty: PropertyRange] {
        var capacityRange = PropertyRange()
        var oneByOneRange = PropertyRange()
        var oneByTwoRange = PropertyRange()
        var oneByThreeRange = PropertyRange()
        var twoByTwoRange = PropertyRange()

        for case let rig as ChestRig in allItems {
            capacityRange.updatedRangeIfNeeded(candidateValue: Float(rig.totalCapacity))
            oneByOneRange.updatedRangeIfNeeded(candidateValue: Float(rig.oneByOneSlots))
            oneByTwoRange.updatedRangeIfNeeded(candidateValue: Float(rig.oneByTwoSlots))
            oneByThreeRange.updatedRangeIfNeeded(candidateValue: Float(rig.oneByThreeSlots))
            twoByTwoRange.updatedRangeIfNeeded(candidateValue: Float(rig.twoByTwoSlots))
        }

        return [
            .capacity: capacityRange,
            .oneByOneSlots: oneByOneRange,
            .oneByTwoSlots: oneByTwoRange,
            .oneByThreeSlots: oneByThreeRange,
            .twoByTwoSlots: twoByTwoRange
        ]
    }

    func getPercentValue(item: Comparable, property: ComparableProperty, traitCollection: UITraitCollection) -> Float {
        guard let rig = item as? ChestRig else { fatalError() }
        let range = getComparedItemsSummaryMap()[property]!

        switch property {
        case .capacity: return scaledValue(propertyValue: Float(rig.totalCapacity), range: range)
        case .oneByOneSlots: return scaledValue(propertyValue: Float(rig.oneByOneSlots), range: range)
        case .oneByTwoSlots: return scaledValue(propertyValue: Float(rig.oneByTwoSlots), range: range)
        case .oneByThreeSlots: return scaledValue(propertyValue: Float(rig.oneByThreeSlots), range: range)
        case .twoByTwoSlots: return scaledValue(propertyValue: Float(rig.twoByTwoSlots), range: range)
        default: fatalError()
        }
    }
}
