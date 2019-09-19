//
//  BBUser.swift
//  BattleBuddy
//
//  Created by Veritas on 9/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct BBUser {
    let nickname: String
    let adsWatched: NSNumber

    init(_ json: [String: Any]) {
        nickname = json["nickname"] as? String ?? "Anonymous"
        adsWatched = json["adsWatched"] as? NSNumber ?? NSNumber(value: 0)
    }
}
