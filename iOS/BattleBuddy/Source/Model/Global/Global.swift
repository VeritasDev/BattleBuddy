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
    let totalAdsWatched: Int
    let ammoMetadata: [AmmoMetadata]
    let adsWatchedLeaderboard: [BBUser]

    init?(json: [String: Any]) {
        guard let ammoMeta = json["ammoMetadata"] as? [String: [String: Any]], let boxedUserCount = json["totalUserCount"] as? NSNumber, let boxedAdCount = json["totalAdsWatched"] as? NSNumber, let leaderboard = json["leaderboard"] as? [String: [Any]], let topAdsWatchedUsers = leaderboard["adsWatched"] as? [[String: Any]] else {
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
        totalAdsWatched = boxedAdCount.intValue
        ammoMetadata = tempAmmoMeta
        adsWatchedLeaderboard = topAdsWatchedUsers.map { BBUser($0) }
    }
}
