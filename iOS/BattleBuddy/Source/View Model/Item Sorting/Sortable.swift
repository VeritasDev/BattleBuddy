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

protocol Sortable: Searchable {
    var sortId: String { get }
    var params: [SortableParam] { get }
    func valueForParam(_ param: SortableParam) -> String

}

protocol Searchable {
    func matchesSearch(_ search: String) -> Bool
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
        case AmmoSortableParam.pen.identifier: return String(Int(penetration))
        case AmmoSortableParam.damage.identifier: return String(Int(totalDamage))
        default: fatalError()
        }
    }
    func matchesSearch(_ search: String) -> Bool {
        return displayName.containsIgnoringCase(search) || caliber.containsIgnoringCase(search)
    }
}

extension Armor: Sortable {
    var sortId: String { return id }
    var params: [SortableParam] { return [ArmorSortableParam.name, ArmorSortableParam.armorType, ArmorSortableParam.armorClass, ArmorSortableParam.maxDurability] }
    func valueForParam(_ param: SortableParam) -> String {
        switch param {
        case ArmorSortableParam.name: return displayName
        case ArmorSortableParam.armorType: return String(armorType.local())
        case ArmorSortableParam.armorClass: return String(armorClass.rawValue)
        case ArmorSortableParam.maxDurability: return String(maxDurability)
        default: fatalError()
        }
    }
    func matchesSearch(_ search: String) -> Bool {
        return displayName.containsIgnoringCase(search)
    }
}

extension Firearm: Sortable {
    var sortId: String { return id }
    var params: [SortableParam] { return [FirearmSortableParam.name, FirearmSortableParam.caliber, FirearmSortableParam.fireRate] }
    func valueForParam(_ param: SortableParam) -> String {
        switch param {
        case FirearmSortableParam.name: return displayNameShort
        case FirearmSortableParam.caliber: return DependencyManagerImpl.shared.ammoUtilitiesManager().caliberDisplayName(caliber)
        case FirearmSortableParam.fireRate: return String(fireRate)
        default: fatalError()
        }
    }
    func matchesSearch(_ search: String) -> Bool {
        return displayName.containsIgnoringCase(search) || caliber.containsIgnoringCase(search)
    }
}
