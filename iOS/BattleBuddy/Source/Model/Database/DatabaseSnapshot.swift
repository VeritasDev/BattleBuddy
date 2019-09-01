//
//  DatabaseSnapshot.swift
//  BattleBuddy
//
//  Created by Mike on 7/27/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum Category: String, CaseIterable {
    case ammo = "ammunition"
    case armor = "armor"
    case firearm = "firearm"
    case grenade = "grenade"
    case magazine = "magazine"
    case medical = "medical"
    case melee = "melee"
    case modification = "modification"
    case modificationBarrel = "modificationBarrel"
    case modificationBipod = "modificationBipod"
    case modificationCharge = "modificationCharge"
    case modificationDevice = "modificationDevice"
    case modificationForegrip = "modificationForegrip"
    case modificationGasblock = "modificationGasblock"
    case modificationHandguard = "modificationHandguard"
    case modificationLauncher = "modificationLauncher"
    case modificationMount = "modificationMount"
    case modificationMuzzle = "modificationMuzzle"
    case modificationOptic = "modificationOptic"
    case modificationOpticNVG = "modificationOpticNVG"
    case modificationOpticThermal = "modificationOpticThermal"
    case modificationPistolgrip = "modificationPistolgrip"
    case modificationReceiver = "modificationReceiver"
    case modificationSight = "modificationSight"
    case modificationStock = "modificationStock"
}

protocol DatabaseSnapshotDelegate {
    func didReceiveDatabaseSnapshot(_ snapshot: DatabaseSnapshot)
    func failedToReceiveDatabaseSnapshot()
}

struct DatabaseCategoryInfo {
    var lastUpdatedDate: Date
    var itemCount: Int
}

struct DatabaseSnapshot {
    let categories: [Category: DatabaseCategoryInfo]
    static let lastCategoryInfoPrefix = "LastDatabaseSnapshot_"

    static func persistedDatabaseSnapshot() -> DatabaseSnapshot? {
        let prefsManager: PreferencesManager = DependencyManager.shared.prefsManager
        var categories: [Category: DatabaseCategoryInfo] = [:]
        for category in Category.allCases {
            let key = keyForCategory(category)
            let timestamp = prefsManager.valueForDouble(key)
            let updateDate = Date(timeIntervalSince1970: timestamp)
            categories[category] = DatabaseCategoryInfo(lastUpdatedDate: updateDate, itemCount: 0)
        }

        return DatabaseSnapshot(categories: categories)
    }

    static func keyForCategory(_ category: Category) -> String {
        return lastCategoryInfoPrefix + category.rawValue
    }

    init(json: [String: Any]) {
        var tempCategories: [Category: DatabaseCategoryInfo] = [:]
        for category in Category.allCases {
            guard let contents = json[category.rawValue] as? [String: Any],
                let boxedTimestamp = contents["modified"] as? NSNumber,
                let boxedCount = contents["count"] as? NSNumber else { continue }

            let lastUpdateDate = Date(timeIntervalSince1970: boxedTimestamp.doubleValue)
            let categoryInfo = DatabaseCategoryInfo(lastUpdatedDate: lastUpdateDate, itemCount: boxedCount.intValue)
            tempCategories[category] = categoryInfo
        }

        categories = tempCategories
    }

    init(categories: [Category: DatabaseCategoryInfo]) {
        self.categories = categories
    }

    func persistAllInfo() {
        let prefsManager: PreferencesManager = DependencyManager.shared.prefsManager
        for (category, info) in categories {
            let key = DatabaseSnapshot.keyForCategory(category)
            prefsManager.update(key, value: info.lastUpdatedDate.timeIntervalSince1970)
        }
    }
}
