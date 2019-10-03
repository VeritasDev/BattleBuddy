//
//  BBUser.swift
//  BattleBuddy
//
//  Created by Veritas on 9/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct BBUser: Equatable {
    let id: String?
    let nickname: String?
    let loyalty: NSNumber

    init(_ json: [String: Any]) {
        id = json["id"] as? String
        nickname = json["nickname"] as? String
        loyalty = json["loyalty"] as? NSNumber ?? NSNumber(value: 0)
    }

    static func == (lhs: BBUser, rhs: BBUser) -> Bool {
        guard let id1 = lhs.id, let id2 = rhs.id else { return false }
        return id1 == id2
    }
}
