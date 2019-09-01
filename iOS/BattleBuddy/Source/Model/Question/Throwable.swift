//
//  Throwable.swift
//  BattleBuddy
//
//  Created by Mike on 7/22/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct Throwable: BaseItem {
    let json: [String : Any]
    let type: ItemType
    let explosionRadiusMin: Int
    let explosionRadiusMax: Int
    let fragmentationCount: Int
    let fuseTime: Float
    let throwableType: ThrowableType

    init?(json: [String: Any]) {
        self.json = json
        self.type = .throwable

        guard BaseItemUtils.baseItemJsonValid(json),
            let type = json["type"] as? String,
            let resolvedType = ThrowableType(rawValue: type),
            let rawFragCount = json["fragCount"] as? NSNumber,
            let rawRadiusMin = json["minDistance"] as? NSNumber,
            let rawRadiusMax = json["maxDistance"] as? NSNumber,
            let rawFuseTime = json["delay"] as? NSNumber else {
                print("ERROR: Throwable missing required parameters in json: \(json)")
                return nil
        }

        throwableType = resolvedType
        fragmentationCount = rawFragCount.intValue
        explosionRadiusMin = rawRadiusMin.intValue
        explosionRadiusMax = rawRadiusMax.intValue
        fuseTime = rawFuseTime.floatValue
    }
}
