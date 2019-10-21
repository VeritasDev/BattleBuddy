//
//  ItemEnums.swift
//  BattleBuddy
//
//  Created by Mike on 8/23/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

enum ItemType: String {
    case firearm = "firearm"
    case melee = "melee"
    case ammo = "ammunition"
    case armor = "armor"
    case medical = "medical"
    case throwable = "grenade"
    case helmet = "helmet"
    case visor = "visor"
    case modification = "modification"

    func localizedTitle() -> String {
        switch self {
        case .firearm: return "main_menu_firearms".local()
        case .melee: return "main_menu_melee".local()
        case .ammo: return "main_menu_ammo".local()
        case .armor: return "main_menu_armor".local()
        case .visor: return "main_menu_visors".local()
        case .medical: return "main_menu_medical".local()
        case .throwable: return "main_menu_throwables".local()
        case .helmet: return "main_menu_helmets".local()
        case .modification: return "main_menu_mods".local()
        }
    }
}

