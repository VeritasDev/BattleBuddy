//
//  AmmoSort.swift
//  BattleBuddy
//
//  Created by Mike on 8/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum AmmoSortableParam: String, SortableParam, CaseIterable {
    case name = "name"
    case caliber = "caliber"
    case pen = "penetration"
    case damage = "damage"

    var identifier: String { return self.rawValue }
    func local(short: Bool) -> String { return self.rawValue.local() }
}

class AmmoSortConfig: SortConfiguration {
    var sortTitle: String = "ammunition".local()
    var params: [SortableParam] = [AmmoSortableParam.name, AmmoSortableParam.caliber, AmmoSortableParam.pen, AmmoSortableParam.damage]
    var defaultSortParam: SortableParam = AmmoSortableParam.pen
    var state: SortState {
        get { return SortState(param: currentSortParam, ascending: ascending) }
        set {
            currentSortParam = newValue.param
            ascending = newValue.ascending
            updateSort()
        }
    }
    var items: [Sortable] { get { return self.ammo } }
    var ammo: [Ammo] = []

    var currentSortParam: SortableParam = AmmoSortableParam.pen
    var ascending: Bool = false

    init(options: [Ammo]) {
        ammo = options
        updateSort()
    }

    func toggleStateForParam(_ param: SortableParam) {
        let sortDir = (param.identifier == currentSortParam.identifier) ? !ascending : false
        state = SortState(param: param, ascending: sortDir)
    }

    func updateSort() {
        ammo.sort {
            switch (self.ascending, self.currentSortParam.identifier) {
            case (true, AmmoSortableParam.name.rawValue): return $0.displayNameShort < $1.displayNameShort
            case (false, AmmoSortableParam.name.rawValue): return $0.displayNameShort > $1.displayNameShort
            case (true, AmmoSortableParam.caliber.rawValue): return $0.caliber < $1.caliber
            case (false, AmmoSortableParam.caliber.rawValue): return $0.caliber > $1.caliber
            case (true, AmmoSortableParam.pen.rawValue): return $0.resolvedPenetration < $1.resolvedPenetration
            case (false, AmmoSortableParam.pen.rawValue): return $0.resolvedPenetration > $1.resolvedPenetration
            case (true, AmmoSortableParam.damage.rawValue): return $0.resolvedDamage < $1.resolvedDamage
            case (false, AmmoSortableParam.damage.rawValue): return $0.resolvedDamage > $1.resolvedDamage
            default: fatalError()
            }
        }
    }
}
