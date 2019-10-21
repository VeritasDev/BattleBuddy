//
//  FirearmSort.swift
//  BattleBuddy
//
//  Created by Mike on 8/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum FirearmSortableParam: String, SortableParam, CaseIterable {
    case name = "name"
    case caliber = "caliber"
    case fireRate = "fire_rate"

    var identifier: String { return self.rawValue }
    func local(short: Bool) -> String { return self.rawValue.local() }
}

class FirearmSortConfig: SortConfiguration {
    let ammoUtilsManager = DependencyManagerImpl.shared.ammoUtilitiesManager()
    var sortTitle: String = "firearms".local()
    var params: [SortableParam] = [FirearmSortableParam.name, FirearmSortableParam.caliber, FirearmSortableParam.fireRate]
    var defaultSortParam: SortableParam = FirearmSortableParam.caliber
    var state: SortState {
        get { return SortState(param: currentSortParam, ascending: ascending) }
        set {
            currentSortParam = newValue.param
            ascending = newValue.ascending
            updateSort()
        }
    }
    var items: [Sortable] { get { return self.firearms } }
    var firearms: [Firearm] = []

    var currentSortParam: SortableParam = FirearmSortableParam.caliber
    var ascending: Bool = false

    init(options: [Firearm]) {
        firearms = options
        updateSort()
    }

    func toggleStateForParam(_ param: SortableParam) {
        let sortDir = (param.identifier == currentSortParam.identifier) ? !ascending : false
        state = SortState(param: param, ascending: sortDir)
    }

    func updateSort() {
        firearms.sort {
            switch (self.ascending, self.currentSortParam.identifier) {
            case (true, FirearmSortableParam.name.rawValue): return $0.displayNameShort < $1.displayNameShort
            case (false, FirearmSortableParam.name.rawValue): return $0.displayNameShort > $1.displayNameShort
            case (true, FirearmSortableParam.caliber.rawValue): return  ammoUtilsManager.caliberDisplayName($0.caliber) < ammoUtilsManager.caliberDisplayName($1.caliber)
            case (false, FirearmSortableParam.caliber.rawValue): return ammoUtilsManager.caliberDisplayName($0.caliber) > ammoUtilsManager.caliberDisplayName($1.caliber)
            case (true, FirearmSortableParam.fireRate.rawValue): return $0.fireRate < $1.fireRate
            case (false, FirearmSortableParam.fireRate.rawValue): return $0.fireRate > $1.fireRate
            default: fatalError()
            }
        }
    }
}
