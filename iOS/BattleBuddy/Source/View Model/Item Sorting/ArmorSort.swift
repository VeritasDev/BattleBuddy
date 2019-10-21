//
//  ArmorSort.swift
//  BattleBuddy
//
//  Created by Mike on 8/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum ArmorSortableParam: String, SortableParam, CaseIterable {
    case name = "name"
    case armorClass = "armor_class"
    case armorType = "armor_type"
    case maxDurability = "armor_points"

    var identifier: String { return self.rawValue }
    func local(short: Bool) -> String { return self.rawValue.local() }
}

class ArmorSortConfig: SortConfiguration {
    var sortTitle: String = "armor".local()
    var params: [SortableParam] = [ArmorSortableParam.name, ArmorSortableParam.armorType, ArmorSortableParam.armorClass, ArmorSortableParam.maxDurability]
    var defaultSortParam: SortableParam = ArmorSortableParam.armorClass
    var state: SortState {
        get { return SortState(param: currentSortParam, ascending: ascending) }
        set {
            currentSortParam = newValue.param
            ascending = newValue.ascending
            updateSort()
        }
    }
    var items: [Sortable] { get { return self.armor } }
    var armor: [Armor]
    var currentSortParam: SortableParam = ArmorSortableParam.armorClass
    var ascending: Bool = false

    init(options: [Armor]) {
        armor = options
        updateSort()
    }

    func toggleStateForParam(_ param: SortableParam) {
        let sortDir = (param.identifier == currentSortParam.identifier) ? !ascending : false
        state = SortState(param: param, ascending: sortDir)
    }

    func updateSort() {
        armor.sort {
            switch (self.ascending, self.currentSortParam.identifier) {
            case (true, ArmorSortableParam.name.rawValue): return $0.displayNameShort < $1.displayNameShort
            case (false, ArmorSortableParam.name.rawValue): return $0.displayNameShort > $1.displayNameShort
            case (true, ArmorSortableParam.armorClass.rawValue): return $0.armorClass.rawValue < $1.armorClass.rawValue
            case (false, ArmorSortableParam.armorClass.rawValue): return $0.armorClass.rawValue > $1.armorClass.rawValue
            case (true, ArmorSortableParam.maxDurability.rawValue): return $0.maxDurability < $1.maxDurability
            case (false, ArmorSortableParam.maxDurability.rawValue): return $0.maxDurability > $1.maxDurability
            case (true, ArmorSortableParam.armorType.rawValue): return $0.armorType.local() < $1.armorType.local()
            case (false, ArmorSortableParam.armorType.rawValue): return $0.armorType.local() > $1.armorType.local()
            default: fatalError()
            }
        }
    }
}
