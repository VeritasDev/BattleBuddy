//
//  ItemListViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/24/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemListViewController: BaseStackViewController {
    var config: ItemListConfig
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    var loaded = false

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(itemType: ItemType) {
        self.config = ItemListConfig(itemType)
        super.init(BaseStackView(spacing: 3, xPaddingCompact: 0.0, yPadding: 10.0))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.title
        let bgColor = UIColor(white: 0.07, alpha: 1.0)
        view.backgroundColor = bgColor
        scrollView.backgroundColor = UIColor(white: 0.07, alpha: 1.0)
    }

    override func viewWillAppear(_ animated: Bool) {
        if loaded { return }

        let hud = JGProgressHUD(style: .dark)
        hud.show(in: self.view)

        switch config.type {
        case .firearm:
            self.dbManager.getAllFirearmsByType { [weak self] firearmMap in
                hud.dismiss(animated: false)
                var firearmSections: [ItemSection] = []
                for firearmType in FirearmType.allCases {
                    if let items = firearmMap[firearmType], items.count > 0 {
                        firearmSections.append(ItemSection(title: firearmType.local(), items: items))
                    }
                }
                self?.config.sections = firearmSections
                self?.buildStackFromConfig()
            }
        case .armor:
            self.dbManager.getAllBodyArmorByClass { [weak self] armorMap in
                hud.dismiss(animated: false)
                var armorSections: [ItemSection] = []
                for armorClass in ArmorClass.allCases {
                    if let items = armorMap[armorClass], items.count > 0 {
                        armorSections.append(ItemSection(title: armorClass.local(), items: items))
                    }
                }
                self?.config.sections = armorSections
                self?.buildStackFromConfig()
            }
        case .rig:
            self.dbManager.getAllChestRigsByClass { [weak self] rigMap in
                hud.dismiss(animated: false)
                var armorSections: [ItemSection] = []
                for armorClass in ArmorClass.allCases {
                    if let items = rigMap[armorClass], items.count > 0 {
                        armorSections.append(ItemSection(title: armorClass.local(), items: items))
                    }
                }
                self?.config.sections = armorSections
                self?.buildStackFromConfig()
            }
        case .helmet:
            self.dbManager.getAllHelmetsByClass { [weak self] armorMap in
                hud.dismiss(animated: false)
                var armorSections: [ItemSection] = []
                for armorClass in ArmorClass.allCases {
                    if let items = armorMap[armorClass], items.count > 0 {
                        armorSections.append(ItemSection(title: armorClass.local(), items: items))
                    }
                }
                self?.config.sections = armorSections
                self?.buildStackFromConfig()
            }
        case .visor:
            self.dbManager.getAllHelmetArmorByClass { armorMap in
                hud.dismiss(animated: false)
                var armorSections: [ItemSection] = []
                for armorClass in ArmorClass.allCases {
                    if let items = armorMap[armorClass], items.count > 0 {
                        armorSections.append(ItemSection(title: armorClass.local(), items: items))
                    }
                }
                self.config.sections = armorSections
                self.buildStackFromConfig()
            }
        case .ammo:
            self.dbManager.getAllAmmoByCaliber { [weak self] ammoMap in
                hud.dismiss(animated: false)

                let allCalibers: [String]
                if let metadata = DependencyManagerImpl.shared.metadataManager().getGlobalMetadata() {
                    let ammoMetadata = metadata.ammoMetadata
                    allCalibers = ammoMetadata.sorted(by: { $0.index < $1.index }).map { $0.caliber }
                } else {
                    allCalibers = Array(ammoMap.keys)
                }

                var ammoSections: [ItemSection] = []
                for caliber in allCalibers {
                    if let items = ammoMap[caliber], items.count > 0 {
                        ammoSections.append(ItemSection(title: caliber, items: items))
                    }
                }
                self?.config.sections = ammoSections
                self?.buildStackFromConfig()
            }
        case .medical:
            self.dbManager.getAllMedicalByType { [weak self] medicalMap in
                hud.dismiss(animated: false)
                var medicalSections: [ItemSection] = []
                for type in MedicalItemType.allCases {
                    if let items = medicalMap[type], items.count > 0 {
                        medicalSections.append(ItemSection(title: type.local(), items: items))
                    }
                }
                self?.config.sections = medicalSections
                self?.buildStackFromConfig()
            }
        default:
            break
        }
    }

    func buildStackFromConfig() {
        loaded = true
        stackView.removeAllArrangedSubviews()

        let allItems = getAllItems()

        for section in config.sections {
            let sectionHeaderView: SectionHeaderView

            if section.allowCompare {
                sectionHeaderView = SectionHeaderView(headerText: section.title, actionText: "compare".local()) { [weak self] in
                    guard let safeSelf = self else { return }
                    let comparison = safeSelf.createComparisonForType(safeSelf.config.type, allItems: allItems, comparedItems: section.items)
                    let compareVC = ItemCompareViewController(comparison)
                    safeSelf.navigationController?.pushViewController(compareVC, animated: true)
                }
            } else {
                sectionHeaderView = SectionHeaderView(headerText: section.title)
            }
            sectionHeaderView.backgroundColor = UIColor(white: 0.07, alpha: 1.0)
            stackView.addArrangedSubview(sectionHeaderView)

            let collectionView = PreviewMenuCollectionView(selectionDelegate: self, items: section.items, cellWidthMutlipler: config.cellWidthMultiplier)
            collectionView.backgroundColor = UIColor(white: 0.07, alpha: 1.0)
            stackView.addArrangedSubview(collectionView)

            let sectionHeightMultiplier: CGFloat = view.isCompactWidth() ? 0.20 : 0.20
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: sectionHeightMultiplier)
                ])
        }
    }

    private func getAllItems() -> [Displayable] {
        var allItems: [Displayable] = []
        for section in config.sections { allItems += section.items }
        return allItems
    }

    private func createComparisonForType(_ type: ItemType, allItems: [Displayable], comparedItems: [Displayable]) -> ItemComparison {
        switch type {
        case .firearm:
            let allFirearms = allItems.map { $0 as! Firearm }
            let comparedFirearms = comparedItems.map { $0 as! Firearm }
            var comparison = FirearmComparison(allFirearms: allFirearms)
            comparison.itemsBeingCompared = comparedFirearms
            return comparison
        case .melee:
            let all = allItems.map { $0 as! MeleeWeapon }
            let compared = comparedItems.map { $0 as! MeleeWeapon }
            var comparison = MeleeWeaponComparison(all)
            comparison.itemsBeingCompared = compared
            return comparison
        case .ammo:
            let all = allItems.map { $0 as! Ammo }
            let compared = comparedItems.map { $0 as! Ammo }
            var comparison = AmmoComparison(allAmmo: all)
            comparison.itemsBeingCompared = compared
            return comparison
        case .armor, .helmet, .visor, .modification:
            let all = allItems.map { $0 as! Armor }
            let compared = comparedItems.map { $0 as! Armor }
            var comparison = ArmorComparison(allArmor: all)
            comparison.itemsBeingCompared = compared
            return comparison
        case .medical:
            let all = allItems.map { $0 as! Medical }
            let compared = comparedItems.map { $0 as! Medical }
            var comparison = MedicalComparison(allMedical: all)
            comparison.itemsBeingCompared = compared
            return comparison
        case .throwable:
            let all = allItems.map { $0 as! Throwable }
            let compared = comparedItems.map { $0 as! Throwable }
            var comparison = ThrowableComparison(all)
            comparison.itemsBeingCompared = compared
            return comparison
        case .rig:
            return ArmorComparison(allArmor: []) // TODO
        }
    }
}


extension ItemListViewController: PreviewMenuSelectionDelegate {
    func didSelectDisplayableItem(_ displayable: Displayable) {
        switch displayable.type {
        case .firearm:
            let firearmVC = ItemDetailsViewController(FirearmDetailsConfiguration(displayable as! Firearm))
            navigationController?.pushViewController(firearmVC, animated: true)
        case .ammo:
            let ammoVC = ItemDetailsViewController(AmmoDetailsConfiguration(displayable as! Ammo))
            navigationController?.pushViewController(ammoVC, animated: true)
        case .armor:
            let armorVC = ItemDetailsViewController(ArmorDetailsConfiguration(displayable as! Armor))
            navigationController?.pushViewController(armorVC, animated: true)
        case .medical:
            let medVC = ItemDetailsViewController(MedicalDetailsConfiguration(displayable as! Medical))
            navigationController?.pushViewController(medVC, animated: true)
        case .modification:
            let modVC = ItemDetailsViewController(ModificationDetailsConfiguration(displayable as! Modification))
            navigationController?.pushViewController(modVC, animated: true)
        default:
            fatalError()
        }
    }
}
