//
//  ArmorUtils.swift
//  BattleBuddy
//
//  Created by Mike on 8/1/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum ArmorClass: Int, CaseIterable, Localizable {
    case none = 0
    case one = 1
    case two = 2
    case three = 3
    case four = 4
    case five = 5
    case six = 6

    func local(short: Bool = false) -> String {
        if short { return String(self.rawValue) }

        switch self {
        case .none: return Localized("armor_class_0")
        case .one: return Localized("armor_class_1")
        case .two: return Localized("armor_class_2")
        case .three: return Localized("armor_class_3")
        case .four: return Localized("armor_class_4")
        case .five: return Localized("armor_class_5")
        case .six: return Localized("armor_class_6")
        }
    }
}

enum ArmorType: String, CaseIterable, Localizable {
    case body
    case helmet
    case visor
    case attachment

    func local(short: Bool = false) -> String {
        switch self {
        case .body: return Localized("armor_type_body")
        case .helmet: return Localized("armor_type_helmet")
        case .visor: return Localized("armor_type_visor")
        case .attachment: return Localized("armor_type_attachment")
        }
    }
}

struct ArmorZonesConfig {
    let topHead: Bool
    let eyes: Bool
    let jaws: Bool
    let ears: Bool
    let nape: Bool
    let chest: Bool
    let stomach: Bool
    let leftArm: Bool
    let rightArm: Bool
    let leftLeg: Bool
    let rightLeg: Bool

    func coveragePercent(type: ArmorType) -> Float {
        var percent: Float = 0.0

        switch type {
        case .body:
            if chest { percent += 0.68 }
            if stomach { percent += 0.16 }
            if leftArm { percent += 0.08 }
            if rightArm { percent += 0.08 }
        case .helmet:
            if topHead { percent += 0.4 }
            if eyes { percent += 0.1 }
            if jaws { percent += 0.1 }
            if ears { percent += 0.2 }
            if nape { percent += 0.2 }
        default: fatalError("NIMP")
        }

        return percent
    }

    func zoneCount() -> Int {
        var count = 0

        if topHead { count += 1 }
        if eyes { count += 1 }
        if jaws { count += 1 }
        if ears { count += 1 }
        if nape { count += 1 }
        if chest { count += 1 }
        if stomach { count += 1 }
        if leftArm { count += 1 }
        if rightArm { count += 1 }
        if leftLeg { count += 1 }
        if rightLeg { count += 1 }

        return count
    }
}

enum ArmorMaterial: String, CaseIterable, Localizable {
    case ceramic = "ceramic"
    case armoredSteel = "steel"
    case aramid = "aramid"
    case uhmwpe = "uhmwpe"
    case combined = "combined"
    case aluminium = "aluminium"
    case glass = "glass"
    case titanium = "titanium"

    func local(short: Bool = false) -> String {
        switch self {
        case .ceramic: return Localized("armor_mat_ceramic")
        case .armoredSteel: return Localized("armor_mat_armored_steel")
        case .aramid: return Localized("armor_mat_aramid")
        case .uhmwpe: return Localized("armor_mat_uhmwpe")
        case .combined: return Localized("armor_mat_combined")
        case .aluminium: return Localized("armor_mat_aluminum")
        case .glass: return Localized("armor_mat_glass")
        case .titanium: return Localized("armor_mat_titanium")
        }
    }

    func destructibility() -> Float {
        switch self {
        case .ceramic: return 0.7
        case .armoredSteel: return 0.55
        case .aramid: return 0.25
        case .uhmwpe: return 0.35
        case .combined: return 0.4
        case .aluminium: return 0.5
        case .glass: return 0.7
        case .titanium: return 0.45
        }
    }
}

enum HearingPenalty: String, CaseIterable, Localizable {
    case none = "none"
    case low = "low"
    case high = "high"

    func local(short: Bool = false) -> String {
        switch self {
        case .none: return "hearing_penalty_none".local()
        case .high: return "hearing_penalty_high".local()
        case .low: return "hearing_penalty_low".local()
        }
    }
}

struct RichochetParams {
    let x: Float
    let y: Float
    let z: Float
}

struct Penalties {
    let ergonomics: Int
    let turnSpeed: Int
    let movementSpeed: Int
    let hearing: HearingPenalty
}
