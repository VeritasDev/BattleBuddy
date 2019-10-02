//
//  Displayable.swift
//  BattleBuddy
//
//  Created by Mike on 7/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol Displayable {
    var identifier: String { get }
    var type: ItemType { get }
    var title: String { get }
    var shortTitle: String { get }
    var subtitle: String? { get }
    var iconImage: UIImage? { get }
    var placeholderImage: UIImage? { get }
    var remoteImageUrl: URL? { get }
    var tint: UIColor? { get }
    var titleFont: UIFont { get }
}

protocol Localizable {
    func local(short: Bool) -> String
}

extension Firearm: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var shortTitle: String { get { return displayNameShort } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 25.0, weight: .bold) } }
    var subtitle: String? { get { return caliber } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var placeholderImage: UIImage? {
        get {
            switch firearmType {
            case .pistol: return UIImage(named: "placeholder_pistol")?.withRenderingMode(.alwaysTemplate)
            case .assaultCarbine: return UIImage(named: "placeholder_carbine")?.withRenderingMode(.alwaysTemplate)
            case .designatedMarksmanRifle: return UIImage(named: "placeholder_dmr")?.withRenderingMode(.alwaysTemplate)
            case .machinegun: return UIImage(named: "placeholder_mg")?.withRenderingMode(.alwaysTemplate)
            case .shotgun: return UIImage(named: "placeholder_shotgun")?.withRenderingMode(.alwaysTemplate)
            case .submachineGun: return UIImage(named: "placeholder_smg")?.withRenderingMode(.alwaysTemplate)
            case .sniperRifle: return UIImage(named: "placeholder_sniper")?.withRenderingMode(.alwaysTemplate)
            case .assaultRifle: return UIImage(named: "placeholder_ar")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}

extension Ammo: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var subtitle: String? { get { return nil } }
    var shortTitle: String { get { return displayNameShort } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 18.0, weight: .bold) } }
    var placeholderImage: UIImage? {
        get {
            switch caliber {
            case "5.45x39mm": return UIImage(named: "545x39_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "5.56x45 NATO": return UIImage(named: "556x45_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "7.62x39mm": return UIImage(named: "762x39_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "9x39mm": return UIImage(named: "9x39_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "9x19 Parabellum": return UIImage(named: "9x19_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "7.62x51mm NATO": return UIImage(named: "762x51_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "HK 4.6x30mm": return UIImage(named: "46x30_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "7.62x54mmR": return UIImage(named: "762x54_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "12ga": return UIImage(named: "12x70_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "20ga": return UIImage(named: "20x70_placeholder")?.withRenderingMode(.alwaysTemplate)
            case ".366 TKM": return UIImage(named: "366_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "9x18mm Makarov": return UIImage(named: "9x18_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "9x21mm Gyurza": return UIImage(named: "9x21_placeholder")?.withRenderingMode(.alwaysTemplate)
            case "7.62x25mm Tokarev": return UIImage(named: "762x25_placeholder")?.withRenderingMode(.alwaysTemplate)
            default: return UIImage(named: "545x39_placeholder")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}

extension Armor: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var subtitle: String? { get { return nil } }
    var shortTitle: String { get { return displayNameShort } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 21.0, weight: .bold) } }
    var placeholderImage: UIImage? {
        get {
            switch (armorClass, armorType) {
            case (.none, .body): return nil
            case (.one, .body): return UIImage(named: "class_1_placeholder")?.withRenderingMode(.alwaysTemplate)
            case (.two, .body): return UIImage(named: "class_2_placeholder")?.withRenderingMode(.alwaysTemplate)
            case (.three, .body): return UIImage(named: "class_3_placeholder")?.withRenderingMode(.alwaysTemplate)
            case (.four, .body): return UIImage(named: "class_4_placeholder")?.withRenderingMode(.alwaysTemplate)
            case (.five, .body): return UIImage(named: "class_5_placeholder")?.withRenderingMode(.alwaysTemplate)
            case (.six, .body): return UIImage(named: "class_6_placeholder")?.withRenderingMode(.alwaysTemplate)

            case (.none, .helmet): return nil
            case (.one, .helmet): return UIImage(named: "class_1_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)
            case (.two, .helmet): return UIImage(named: "class_2_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)
            case (.three, .helmet): return UIImage(named: "class_3_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)
            case (.four, .helmet): return UIImage(named: "class_4_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)
            case (.five, .helmet): return UIImage(named: "class_5_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)
            case (.six, .helmet): return UIImage(named: "class_6_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)

            case (_, .visor): return nil
            case (_, .attachment): return nil
            }
        }
    }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}

extension Medical: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var subtitle: String? { get { return nil } }
    var shortTitle: String { get { return displayNameShort } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 18.0, weight: .bold) } }
    var placeholderImage: UIImage? {
        get {
            switch medicalItemType {
            case .medkit: return UIImage(named: "placeholder_medkit")?.withRenderingMode(.alwaysTemplate)
            case .painkiller: return UIImage(named: "placeholder_painkiller")?.withRenderingMode(.alwaysTemplate)
            case .accessory: return UIImage(named: "placeholder_medical")?.withRenderingMode(.alwaysTemplate)
            case .stimulator: return UIImage(named: "placeholder_stims")?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}

extension Throwable: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var subtitle: String? { get { return nil } }
    var shortTitle: String { get { return displayNameShort } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 22.0, weight: .bold) } }
    var placeholderImage: UIImage? { get {  return UIImage(named: "placeholder_throwable")?.withRenderingMode(.alwaysTemplate) } }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}

extension MeleeWeapon: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var subtitle: String? { get { return nil } }
    var shortTitle: String { get { return displayNameShort } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 22.0, weight: .bold) } }
    var placeholderImage: UIImage? { get { return UIImage(named: "placeholder_melee")?.withRenderingMode(.alwaysTemplate) } }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}

extension Modification: Displayable {
    var identifier: String { get { return id } }
    var title: String { get { return displayName } }
    var subtitle: String? { get { return nil } }
    var shortTitle: String { get { return displayNameShort } }
    var tint: UIColor? { get { return UIColor(white: 0.7, alpha: 1.0) } }
    var titleFont: UIFont { get { return UIFont.systemFont(ofSize: 18.0, weight: .bold) } }
    var placeholderImage: UIImage? {
        get {
            return UIImage(named: "545x39_placeholder")?.withRenderingMode(.alwaysTemplate)
        }
    }
    var remoteImageUrl: URL? { get { return URL(string: "https://static.tarkov-database.com/image/icon/\(id).png") } }
    var iconImage: UIImage? { get { return nil } }
}
