//
//  MainMenu.swift
//  BattleBuddy
//
//  Created by Mike on 6/30/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

enum MenuItemType: CaseIterable, Localizable {
    // Items
    case firearms
    case ammunition
    case mods
    case armor
    case rig
    case helmets
    case visors
    case medical
    case melee
    case throwables

    // Market
    case priceCheck
    case currencyConverter

    // Learn
    case ballistics
    case healthCalc
    case penChanceCalc
    case soundTraining
    case budPoints
    case combatSim
    case shootingRange

    func local(short: Bool = false) -> String {
        switch self {
        case .ammunition: return Localized("main_menu_ammo")
        case .armor: return Localized("main_menu_armor")
        case .rig: return Localized("main_menu_chest_rigs")
        case .helmets: return Localized("main_menu_helmets")
        case .visors: return Localized("main_menu_visors")
        case .ballistics: return Localized("main_menu_ballistics")
        case .healthCalc: return Localized("main_menu_health_calc")
        case .firearms: return Localized("main_menu_firearms")
        case .mods: return Localized("main_menu_mods")
        case .melee: return Localized("main_menu_melee")
        case .medical: return Localized("main_menu_medical")
        case .throwables: return Localized("main_menu_throwables")
        case .penChanceCalc: return Localized("pen_chance")
        case .soundTraining: return Localized("sound_training")
        case .budPoints: return Localized("bud_points")
        case .combatSim: return "main_menu_combat_sim".local()
        case .shootingRange: return "main_menu_shooting_range".local()
        case .currencyConverter: return "main_menu_currency_converter".local()
        case .priceCheck: return "main_menu_price_check".local()
        }
    }
}

enum MenuItemSize {
    case small
    case medium
    case large
}

enum MenuDisplayStyle {
    case push
    case present
}

struct MainMenuItem {
    let type: MenuItemType
    let compactSize: MenuItemSize
    let regularSize: MenuItemSize

    func displayStyle() -> MenuDisplayStyle {
        switch type {
        default: return .push
        }
    }

    func loadDestinationViewController(handler: @escaping (UIViewController) -> Void) {
        switch type {
        case .firearms:
            handler(ItemListViewController(itemType: .firearm))
            return
        case .mods:
            handler(ItemListViewController(itemType: .modification))
            return
        case .ammunition:
            handler(ItemListViewController(itemType: .ammo))
            return
        case .armor:
            handler(ItemListViewController(itemType: .armor))
            return
        case .rig:
            handler(ItemListViewController(itemType: .rig))
            return
        case .helmets:
            handler(ItemListViewController(itemType: .helmet))
            return
        case .visors:
            handler(ItemListViewController(itemType: .visor))
            return
        case .medical:
            handler(ItemListViewController(itemType: .medical))
            return
        case .ballistics:
            handler(PostViewController(BallisticsPost()))
            return
        case .healthCalc:
            DependencyManagerImpl.shared.databaseManager().getCharacters { characters in
                handler(AdvancedBallisticsViewController(characterOptions: characters))
                return
            }
        case .penChanceCalc:
            handler(PenChanceCalcViewController())
            return
        case .soundTraining:
            handler(SoundTrainingViewController())
            return
        case .budPoints:
            handler(PostViewController(BudPost()))
            return
        case .combatSim:
            DependencyManagerImpl.shared.databaseManager().getCharacters { characters in
                handler(CombatSimViewController(characters: characters))
                return
            }
        case .shootingRange:
            DependencyManagerImpl.shared.databaseManager().getCharacters { characters in
                guard let defaultChar = characters.first else { return }
                handler(ShootingRangeViewController(defaultCharacter: defaultChar))
                return
            }
        case .throwables:
            DependencyManagerImpl.shared.databaseManager().getAllThrowables { throwables in
                handler(BaseItemPreviewViewController(delegate: nil, config: ThrowablesPreviewConfiguration(items: throwables)))
                return
            }
        case .melee:
            DependencyManagerImpl.shared.databaseManager().getAllMelee { melee in
                handler(BaseItemPreviewViewController(delegate: nil, config: MeleePreviewConfiguration(items: melee)))
                return
            }
        case .priceCheck:
            DependencyManagerImpl.shared.databaseManager().getAllMarketItems { marketItems in
                let controller = PriceCheckController(marketItems)
                handler(PriceCheckViewController(controller))
                return
            }
        case .currencyConverter:
            break
        }
    }

    func cardImage() -> UIImage? {
        switch type {
        case .firearms: return UIImage(named: "card_hero_firearms")
        case .mods: return UIImage(named: "card_hero_mods")
        case .ammunition: return UIImage(named: "card_hero_ammo")
        case .melee: return UIImage(named: "card_hero_melee")
        case .throwables: return UIImage(named: "card_hero_throwables")
        case .armor: return UIImage(named: "card_hero_armor")
        case .rig: return UIImage(named: "card_hero_chest_rigs")
        case .helmets: return UIImage(named: "card_hero_helmets")
        case .visors: return UIImage(named: "card_hero_visors")
        case .ballistics: return UIImage(named: "card_hero_ballistics")
        case .medical: return UIImage(named: "card_hero_medical")
        case .penChanceCalc: return UIImage(named: "card_hero_pen_chance")
        case .healthCalc: return UIImage(named: "card_hero_health_calc")
        case .soundTraining: return UIImage(named: "card_hero_sound_training")
        case .budPoints: return UIImage(named: "card_hero_bud_points")
        case .combatSim: return UIImage(named: "card_hero_combat_sim")
        case .shootingRange: return UIImage(named: "card_hero_combat_sim")
        case .priceCheck: return UIImage(named: "card_hero_price_check")
        case .currencyConverter: return UIImage(named: "card_hero_currency_converter")
        }
    }

    func configureCell(_ cell: MainMenuCell) {
        cell.imageView.image = cardImage()
        cell.label.font = UIFont.systemFont(ofSize: 32.0, weight: .heavy)
        cell.label.textColor = .white
        cell.label.layer.shadowColor = UIColor.black.cgColor
        cell.label.text = type.local()
    }

    func updateLayoutForCell(_ cell: MainMenuCell) {
        cell.imageView.frame = cell.containerView.bounds

        let containerWidth = cell.containerView.frame.width
        let containerHeight = cell.containerView.frame.height
        let xPadding: CGFloat = 24.0
        let yPadding: CGFloat = 12.0
        let labelWidth = containerWidth - (2 * xPadding)
        cell.label.frame = CGRect.init(x: 0, y: 0, width: labelWidth, height: 0)
        cell.label.sizeToFit()
        let labelHeight = cell.label.frame.height
        cell.label.frame = CGRect.init(x: xPadding, y: containerHeight - labelHeight - yPadding, width: labelWidth, height: labelHeight)
    }
}
