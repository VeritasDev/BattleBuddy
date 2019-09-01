//
//  Trader.swift
//  BattleBuddy
//
//  Created by Mike on 7/24/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

enum Trader: Localizable, CaseIterable {
    case prapor
    case therapist
    case skier
    case peacekeeper
    case mechanic
    case ragman

    func local(short: Bool = false) -> String {
        switch self {
        case .prapor: return Localized("prapor")
        case .therapist: return Localized("therapist")
        case .skier: return Localized("skier")
        case .peacekeeper: return Localized("peacekeeper")
        case .mechanic: return Localized("mechanic")
        case .ragman: return Localized("ragman")
        }
    }

    func heroImage() -> UIImage {
        switch self {
        case .prapor: return UIImage(named: "prapor")!
        case .therapist: return UIImage(named: "therapist")!
        case .skier: return UIImage(named: "skier")!
        case .peacekeeper: return UIImage(named: "peacekeeper")!
        case .mechanic: return UIImage(named: "mechanic")!
        case .ragman: return UIImage(named: "ragman")!
        }
    }

    func inventoryImageName(level: Int) -> String {
        let filename: String

        switch self {
        case .prapor: filename = "prapor"
        case .therapist: filename = "therapist"
        case .skier: filename = "skier"
        case .peacekeeper: filename = "peacekeeper"
        case .mechanic: filename = "mechanic"
        case .ragman: filename = "ragman"
        }

        return filename + "_ll" + String(level) + ".jpg"
    }
}
