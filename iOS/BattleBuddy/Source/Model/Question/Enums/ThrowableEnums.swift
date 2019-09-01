//
//  ThrowableEnums.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum ThrowableType: String, CaseIterable, Localizable {
    case frag = "frag"
    case flash = "flash"
    case smoke = "smoke"

    func local(short: Bool = false) -> String {
        switch self {
        case .frag: return Localized("throwable_frag")
        case .flash: return Localized("throwable_flash")
        case .smoke: return Localized("throwable_smoke")
        }
    }
}
