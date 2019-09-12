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
            self.dbManager.getAllFirearmsByType { firearmMap in
                hud.dismiss(animated: false)
                var firearmSections: [ItemSection] = []
                for firearmType in FirearmType.allCases {
                    if let items = firearmMap[firearmType], items.count > 0 {
                        firearmSections.append(ItemSection(title: firearmType.local(), items: items))
                    }
                }
                self.config.sections = firearmSections
                self.buildStackFromConfig()
            }
        case .armor:
            self.dbManager.getAllBodyArmorByClass { armorMap in
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
            guard let metadata = DependencyManagerImpl.shared.metadataManager().getGlobalMetadata() else { return }
            let ammoMetadata = metadata.ammoMetadata
            let orderedMetadata = ammoMetadata.sorted(by: { $0.index < $1.index })

            self.dbManager.getAllAmmoByCaliber { ammoMap in
                hud.dismiss(animated: false)
                var ammoSections: [ItemSection] = []
                for metadata in orderedMetadata {
                    let caliber = metadata.caliber
                    if let items = ammoMap[caliber], items.count > 0 {
                        ammoSections.append(ItemSection(title: caliber, items: items))
                    }
                }
                self.config.sections = ammoSections
                self.buildStackFromConfig()
            }
        case .medical:
            self.dbManager.getAllMedicalByType { medicalMap in
                hud.dismiss(animated: false)
                var medicalSections: [ItemSection] = []
                for type in MedicalItemType.allCases {
                    if let items = medicalMap[type], items.count > 0 {
                        medicalSections.append(ItemSection(title: type.local(), items: items))
                    }
                }
                self.config.sections = medicalSections
                self.buildStackFromConfig()
            }
        default:
            fatalError()
        }
    }

    func buildStackFromConfig() {
        loaded = true
        stackView.removeAllArrangedSubviews()

        for section in config.sections {
            let sectionHeaderView = SectionHeaderView(headerText: section.title)
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
        default:
            fatalError()
        }
    }
}
