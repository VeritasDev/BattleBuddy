//
//  Global.swift
//  BattleBuddy
//
//  Created by Veritas on 9/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct AmmoMetadata {
    let caliber: String
    let displayName: String
    let index: Int
}

struct GlobalMetadata {
    let totalUserCount: Int
    let totalLoyalty: Int
    let ammoMetadata: [AmmoMetadata]
    let loyaltyLeaderboard: [BBUser]

    init?(json: [String: Any]) {
        guard let ammoMeta = json["ammoMetadata"] as? [String: [String: Any]], let boxedUserCount = json["totalUserCount"] as? NSNumber, let boxedLoyalty = json["totalLoyalty"] as? NSNumber, let leaderboard = json["loyalty"] as? [[String: Any]] else {
            return nil
        }

        var tempAmmoMeta: [AmmoMetadata] = []
        for caliber in ammoMeta.keys {
            guard let data = ammoMeta[caliber], let displayName = data["displayName"] as? String,
                let rawIndex = data["index"] as? NSNumber else {
                    return nil
            }

            tempAmmoMeta.append(AmmoMetadata(caliber: caliber, displayName: displayName, index: rawIndex.intValue))
        }

        totalUserCount = boxedUserCount.intValue
        totalLoyalty = boxedLoyalty.intValue
        ammoMetadata = tempAmmoMeta
        loyaltyLeaderboard = leaderboard.map { BBUser($0) }
    }
}
