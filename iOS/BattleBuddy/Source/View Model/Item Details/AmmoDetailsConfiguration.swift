//
//  AmmoDetailsConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

// TODO: Row of other rounds of same caliber?
class AmmoDetailsConfiguration: NSObject, ItemDetailsConfiguration, UITableViewDelegate, UITableViewDataSource {
    var ammo: Ammo
    var item: BaseItem
    var delegate: ItemDetailsSectionDelegate?

    let propertiesStackView = BaseStackView(xPaddingCompact: 0.0)
    let propertiesHeaderView = SectionHeaderView(headerText: Localized("properties"))
    lazy var propertiesTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let caliberCell = BaseTableViewCell(text: Localized("caliber"))
    let gunsCell = BaseTableViewCell(text: Localized("guns_for_caliber"))
    let penetrationCell = BaseTableViewCell(text: Localized("penetration"), accessory: .none, selection: .none)
    let damageCell = BaseTableViewCell(text: Localized("damage"), accessory: .none, selection: .none)
    let armorDamageCell = BaseTableViewCell(text: Localized("armor_damage"), accessory: .none, selection: .none)
    let fragChanceCell = BaseTableViewCell(text: Localized("frag_chance"), accessory: .none, selection: .none)
    let muzzleVelocityCell = BaseTableViewCell(text: Localized("muzzle_velocity"), accessory: .none, selection: .none)
    let tracerCell = BaseTableViewCell(text: Localized("tracer"), accessory: .none, selection: .none)
    let subsonicCell = BaseTableViewCell(text: Localized("subsonic"), accessory: .none, selection: .none)
    lazy var propertiesCells = { [caliberCell, gunsCell, penetrationCell, damageCell, armorDamageCell, fragChanceCell, muzzleVelocityCell, tracerCell, subsonicCell] }()

    let exploreStackView = BaseStackView(xPaddingCompact: 0.0)
    let exploreHeaderView = SectionHeaderView(headerText: Localized("explore"))
    lazy var exploreTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let compareCell = BaseTableViewCell(text: Localized("compare"))
    let penChanceCalcCell = BaseTableViewCell(text: "pen_chance".local())
    let damageCalcCell = BaseTableViewCell(text: "health_calc_title".local())
    lazy var exploreCells = { [compareCell, penChanceCalcCell, damageCalcCell] }()

    init(_ ammo: Ammo) {
        self.ammo = ammo
        self.item = ammo

        super.init()

        propertiesStackView.addArrangedSubview(propertiesHeaderView)
        propertiesStackView.addArrangedSubview(propertiesTableView)

        exploreStackView.addArrangedSubview(exploreHeaderView)
        exploreStackView.addArrangedSubview(exploreTableView)

        caliberCell.detailTextLabel?.text = ammo.caliber
        penetrationCell.detailTextLabel?.text = String(ammo.penetration)

        if ammo.projectileCount > 1 {
            damageCell.detailTextLabel?.text = "\(Int(ammo.resolvedDamage)) (\(ammo.damage)x\(ammo.projectileCount))"
            armorDamageCell.detailTextLabel?.text = "\(Int(ammo.resolvedArmorDamage)) (\(ammo.armorDamage)x\(ammo.projectileCount))"
        } else {
            damageCell.detailTextLabel?.text = String(ammo.damage)
            armorDamageCell.detailTextLabel?.text = String(ammo.armorDamage)
        }


        fragChanceCell.detailTextLabel?.text = String(Int(ammo.fragChance * 100)) + "%"
        tracerCell.detailTextLabel?.text = Localized(ammo.tracer ? "yes" : "no")
        subsonicCell.detailTextLabel?.text = Localized(ammo.subsonic ? "yes" : "no")
        muzzleVelocityCell.detailTextLabel?.text = String(ammo.muzzleVelocity)

        setupConstraints()
    }

    func setupConstraints() {
        let propertyTableViewHeight = CGFloat(propertiesCells.count) * propertiesTableView.rowHeight
        let totalPropertyStackHeight: CGFloat = propertiesHeaderView.height() + propertyTableViewHeight + propertiesStackView.totalPadding
        propertiesStackView.constrainHeight(totalPropertyStackHeight)

        let exlporeTableViewHeight = CGFloat(exploreCells.count) * exploreTableView.rowHeight
        let totalExploreStackHeight: CGFloat = exploreHeaderView.height() + exlporeTableViewHeight + exploreStackView.totalPadding
        exploreStackView.constrainHeight(totalExploreStackHeight)
    }

    func getArrangedSubviews() -> [UIView] {
        return [propertiesStackView, exploreStackView]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case propertiesTableView: return propertiesCells.count
        case exploreTableView: return exploreCells.count
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case propertiesTableView: return propertiesCells[indexPath.row]
        case exploreTableView: return exploreCells[indexPath.row]
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)

        let dbManager = DependencyManagerImpl.shared.databaseManager()

        switch cell {
        case caliberCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllAmmoOfCaliber(caliber: ammo.caliber) { ammo in
                self.delegate?.showLoading(show: false)

                let ammoOfCaliberVC = BaseItemPreviewViewController(delegate: nil, config: AmmoPreviewConfiguration(items:ammo))
                ammoOfCaliberVC.title = self.ammo.caliber
                self.delegate?.showViewController(viewController: ammoOfCaliberVC)
            }
        case gunsCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllFirearmsOfCaliber(caliber: ammo.caliber) { allFirearms in
                self.delegate?.showLoading(show: false)

                let firearmVC = BaseItemPreviewViewController(delegate: nil, config: FirearmPreviewConfiguration(items: allFirearms))
                firearmVC.title = self.ammo.caliber
                self.delegate?.showViewController(viewController: firearmVC)
            }
        case compareCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllAmmo { allAmmo in
                self.delegate?.showLoading(show: false)

                let compareOptionsVC = ComparisonOptionsViewController(AmmoComparison(self.ammo, allAmmo: allAmmo))
                self.delegate?.showViewController(viewController: compareOptionsVC)
            }

        case penChanceCalcCell:
            let penChanceCalcVC = PenChanceCalcViewController()
            penChanceCalcVC.ammo = ammo
            delegate?.showViewController(viewController: penChanceCalcVC)
        case damageCalcCell:
            self.delegate?.showLoading(show: true)

            dbManager.getCharacters { characters in
                self.delegate?.showLoading(show: false)

                let damageCalcVC = HealthCalcViewController(characters: characters)
                damageCalcVC.ammo = self.ammo
                self.delegate?.showViewController(viewController: damageCalcVC)
            }
        default:
            fatalError()
        }
    }
}
