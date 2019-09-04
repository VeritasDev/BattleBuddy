//
//  MeleeDetailsConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/17/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class MeleeWeaponDetailsConfiguration: NSObject, ItemDetailsConfiguration, UITableViewDelegate, UITableViewDataSource {
    var meleeWeapon: MeleeWeapon
    var item: BaseItem
    var delegate: ItemDetailsSectionDelegate?

    let propertiesStackView = BaseStackView(xPaddingCompact: 0.0)
    let propertiesHeaderView = SectionHeaderView(headerText: Localized("properties"))
    lazy var propertiesTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let stabDamageCell = BaseTableViewCell(text: Localized("stab_dmg"), accessory: .none, selection: .none)
    let stabRateCell = BaseTableViewCell(text: Localized("stab_rate"), accessory: .none, selection: .none)
    let stabRangeCell = BaseTableViewCell(text: Localized("stab_range"), accessory: .none, selection: .none)
    let slashDamageCell = BaseTableViewCell(text: Localized("slash_dmg"), accessory: .none, selection: .none)
    let slashRateCell = BaseTableViewCell(text: Localized("slash_rate"), accessory: .none, selection: .none)
    let slashRangeCell = BaseTableViewCell(text: Localized("slash_range"), accessory: .none, selection: .none)
    let compareCell = BaseTableViewCell(text: Localized("compare"))
    lazy var propertiesCells = { [stabDamageCell, stabRateCell, stabRangeCell, slashDamageCell, slashRateCell, slashRangeCell, compareCell] }()

    init(_ melee: MeleeWeapon) {
        self.meleeWeapon = melee
        self.item = melee

        super.init()

        propertiesStackView.addArrangedSubview(propertiesHeaderView)
        propertiesStackView.addArrangedSubview(propertiesTableView)

        stabDamageCell.detailTextLabel?.text = String(melee.stabDamage)
        stabRateCell.detailTextLabel?.text = String(melee.stabRate)
        stabRangeCell.detailTextLabel?.text = String(melee.stabRange) + "meters_abbr".local()

        slashDamageCell.detailTextLabel?.text = String(melee.slashDamage)
        slashRateCell.detailTextLabel?.text = String(melee.slashRate)
        slashRangeCell.detailTextLabel?.text = String(melee.slashRange) + "meters_abbr".local()

        setupConstraints()
    }

    func setupConstraints() {
        let propertiesTableViewHeight = CGFloat(propertiesCells.count) * propertiesTableView.rowHeight
        let totalPropertyCardHeight: CGFloat = propertiesHeaderView.height() + propertiesTableViewHeight + propertiesStackView.totalPadding
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

        let dbManager = DependencyManagerImpl.shared.databaseManager()

        switch cell {
        case compareCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllMelee { melee in
                self.delegate?.showLoading(show: false)
                self.delegate?.showViewController(viewController: ComparisonOptionsViewController(MeleeWeaponComparison(melee)))
            }
        default: fatalError()
        }
    }
}
