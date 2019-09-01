//
//  MedicalDetailsConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/17/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

import UIKit

class MedicalDetailsConfiguration: NSObject, ItemDetailsConfiguration, UITableViewDelegate, UITableViewDataSource {
    var medicalItem: Medical
    var item: BaseItem
    var delegate: ItemDetailsSectionDelegate?

    @objc dynamic var maxResourceAmount: Int = 0
    @objc dynamic var totalUses: Int = 0
    @objc dynamic var useTime: Int = 0

    let propertiesStackView = BaseStackView(xPaddingCompact: 0.0)
    let propertiesHeaderView = SectionHeaderView(headerText: Localized("properties"))
    lazy var propertiesTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let typeCell = BaseTableViewCell(text: Localized("type"), accessory: .none, selection: .none)
    let resourceAmountCell = BaseTableViewCell(text: nil, accessory: .none, selection: .none)
    let useTimeCell = BaseTableViewCell(text: Localized("use_time"), accessory: .none, selection: .none)
    let effectDurationCell = BaseTableViewCell(text: Localized("effect_duration"), accessory: .none, selection: .none)
    let removesPainCell = BaseTableViewCell(text: Localized("removes_pain"), accessory: .none, selection: .none)
    let removesBloodlossCell = BaseTableViewCell(text: Localized("removes_bloodloss"), accessory: .none, selection: .none)
    let removesContusionCell = BaseTableViewCell(text: Localized("removes_contusion"), accessory: .none, selection: .none)
    let removesFractureCell = BaseTableViewCell(text: Localized("removes_fracture"), accessory: .none, selection: .none)
    let compareCell = BaseTableViewCell(text: Localized("compare"))
    lazy var propertiesCells: [BaseTableViewCell] = {
        switch medicalItem.medicalItemType {
        case .medkit:
            return [typeCell, resourceAmountCell, useTimeCell, removesBloodlossCell, removesContusionCell, removesFractureCell, compareCell]
        case .painkiller:
            return [typeCell, resourceAmountCell, useTimeCell, effectDurationCell, removesPainCell, removesBloodlossCell, removesContusionCell, removesFractureCell, compareCell]
        case .accessory:
            return [typeCell, resourceAmountCell, useTimeCell, removesPainCell, removesBloodlossCell, removesContusionCell, removesFractureCell, compareCell]
        case .stimulator:
            return [typeCell, resourceAmountCell, useTimeCell, effectDurationCell, removesPainCell, removesBloodlossCell, removesContusionCell, removesFractureCell, compareCell]
        }
    }()

    init(_ medicalItem: Medical) {
        self.medicalItem = medicalItem
        self.item = medicalItem

        super.init()

        propertiesStackView.addArrangedSubview(propertiesHeaderView)
        propertiesStackView.addArrangedSubview(propertiesTableView)

        typeCell.detailTextLabel?.text = medicalItem.medicalItemType.local()

        switch medicalItem.medicalItemType {

        case .medkit:
            resourceAmountCell.textLabel?.text = Localized("hp_resource")
            resourceAmountCell.detailTextLabel?.text = String(medicalItem.maxResourceAmount)
        case .painkiller, .accessory, .stimulator:
            resourceAmountCell.textLabel?.text = Localized("use_count")
            resourceAmountCell.detailTextLabel?.text = String(medicalItem.totalUses)
        }
        useTimeCell.detailTextLabel?.text = String(medicalItem.useTime) + Localized("seconds_abbr")
        effectDurationCell.detailTextLabel?.text = String(medicalItem.effectDuration) + Localized("seconds_abbr")
        removesPainCell.detailTextLabel?.text = medicalItem.removesPain ? Localized("yes") : Localized("no")
        removesBloodlossCell.detailTextLabel?.text = medicalItem.removesBloodloss ? Localized("yes") : Localized("no")
        removesContusionCell.detailTextLabel?.text = medicalItem.removesContusion ? Localized("yes") : Localized("no")
        removesFractureCell.detailTextLabel?.text = medicalItem.removesFracture ? Localized("yes") : Localized("no")

        setupConstraints()
    }

    func setupConstraints() {
        let propertyTableViewHeight = CGFloat(propertiesCells.count) * propertiesTableView.rowHeight
        let totalPropertyCardHeight: CGFloat = propertiesHeaderView.height() + propertyTableViewHeight + propertiesStackView.totalPadding
        propertiesStackView.constrainHeight(totalPropertyCardHeight)
    }

    func getArrangedSubviews() -> [UIView] {
        return [propertiesStackView]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case propertiesTableView: return propertiesCells.count
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case propertiesTableView: return propertiesCells[indexPath.row]
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)

        let dbManager = DependencyManagerImpl.shared.databaseManager
        switch cell {
        case compareCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllMedical { allMedical in
                self.delegate?.showLoading(show: false)

                let compareOptionsVC = ComparisonOptionsViewController(MedicalComparison(self.medicalItem, allMedical: allMedical))
                self.delegate?.showViewController(viewController: compareOptionsVC)
            }
        default:
            fatalError()
        }
    }
}
