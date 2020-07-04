//
//  MarketItem.swift
//  BattleBuddy
//
//  Created by Veritas on 6/29/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import Foundation

struct MarketItem: Hashable {
    let itemId: String
    let name: String
    let shortName: String
    let avgPrice24: Int
    let slots: Int
    let pricePerSlot: Int
    let diff24h: Double
    var isFavorite: Bool = false

    init?(json: [String: Any]) {
        guard let id = json["_id"] as? String,
            let itemName = json["name"] as? String,
            let shortItemName = json["shortName"] as? String,
            let boxedAvgPrice24 = json["avgPrice24h"] as? NSNumber,
            let boxedSlots = json["slots"] as? NSNumber,
            let boxedDiff24h = json["diff24h"] as? NSNumber else {
                return nil
        }

        itemId = id
        name = itemName
        shortName = shortItemName
        avgPrice24 = boxedAvgPrice24.intValue
        slots = boxedSlots.intValue
        pricePerSlot = (slots > 0) ? avgPrice24 / slots : 0
        diff24h = boxedDiff24h.doubleValue / 100.0
    }
}

extension MarketItem: Searchable {
    func matchesSearch(_ search: String) -> Bool {
        return name.containsIgnoringCase(search) || shortName.containsIgnoringCase(search)
    }
}
