//
//  MedicalEnums.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum MedicalItemType: String, CaseIterable, Localizable {
    case medkit = "medkit"
    case painkiller = "drug"
    case accessory = "accessory"
    case stimulator = "stimulator"

    func local(short: Bool = false) -> String {
        switch self {
        case .medkit: return Localized("medkit")
        case .painkiller: return Localized("painkiller")
        case .accessory: return Localized("accessory")
        case .stimulator: return Localized("stimulator")
        }
    }
}
