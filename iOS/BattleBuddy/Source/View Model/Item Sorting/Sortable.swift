//
//  Sortable.swift
//  BattleBuddy
//
//  Created by Mike on 8/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol SortableParam: Localizable {
    var identifier: String { get }
}

protocol Sortable {
    var sortId: String { get }
    var params: [SortableParam] { get }
    func valueForParam(_ param: SortableParam) -> String
}

struct SortState {
    var param: SortableParam
    var ascending: Bool
}

protocol SortConfiguration {
    var sortTitle: String { get }
    var params: [SortableParam] { get }
    var defaultSortParam: SortableParam { get }
    var state: SortState { get set }
    var items: [Sortable] { get }
    func toggleStateForParam(_ param: SortableParam)
}

extension Ammo: Sortable {
    var sortId: String { return id }
    var params: [SortableParam] { return AmmoSortableParam.allCases }
    func valueForParam(_ param: SortableParam) -> String {
        switch param.identifier {
        case AmmoSortableParam.name.identifier: return displayNameShort
        case AmmoSortableParam.caliber.identifier: return DependencyManagerImpl.shared.ammoUtilitiesManager().caliberDisplayName(caliber)
        case AmmoSortableParam.pen.identifier: return String(Int(resolvedPenetration))
        case AmmoSortableParam.damage.identifier: return String(Int(resolvedDamage))
        default: fatalError()
        }
    }
}

extension Armor: Sortable {
    var sortId: String { return id }
    var params: [SortableParam] { return [ArmorSortableParam.name, ArmorSortableParam.armorClass, ArmorSortableParam.maxDurability] }
    func valueForParam(_ param: SortableParam) -> String {
        switch param {
        case ArmorSortableParam.name: return displayName
        case ArmorSortableParam.armorClass: return String(resolvedArmorClass)
        case ArmorSortableParam.maxDurability: return String(maxDurability)
        default: fatalError()
        }
    }
}
