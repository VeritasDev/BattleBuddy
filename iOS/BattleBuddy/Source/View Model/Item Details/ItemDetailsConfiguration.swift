//
//  ItemDetailsConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol ItemDetailsConfiguration: class {
    var item: BaseItem { get }
    func getArrangedSubviews() -> [UIView]
    var delegate: ItemDetailsSectionDelegate? { get set }
}

protocol ItemDetailsSectionDelegate {
    func showLoading(show: Bool)
    func showViewController(viewController: UIViewController)
}

class ItemDetailsConfigurationFactory {
    static func configuredItemDetailsViewController(displayable: Displayable) -> ItemDetailsViewController {
        switch displayable.type {
        case .firearm: return ItemDetailsViewController(FirearmDetailsConfiguration(displayable as! Firearm))
        case .modification: return ItemDetailsViewController(FirearmDetailsConfiguration(displayable as! Firearm)) // TODO
        case .ammo: return ItemDetailsViewController(AmmoDetailsConfiguration(displayable as! Ammo))
        case .armor, .helmet, .visor: return ItemDetailsViewController(ArmorDetailsConfiguration(displayable as! Armor))
        case .rig: return ItemDetailsViewController(ChestRigDetailsConfiguration(displayable as! ChestRig))
        case .medical: return ItemDetailsViewController(MedicalDetailsConfiguration(displayable as! Medical))
        case .throwable: return ItemDetailsViewController(ThrowableDetailsConfiguration(displayable as! Throwable))
        case .melee: return ItemDetailsViewController(MeleeWeaponDetailsConfiguration(displayable as! MeleeWeapon))
        }
    }
}
