//
//  FirearmDetailsConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class FirearmDetailsConfiguration: NSObject, ItemDetailsConfiguration, UITableViewDelegate, UITableViewDataSource {
    var firearm: Firearm
    var item: BaseItem
    var delegate: ItemDetailsSectionDelegate?

    let propertiesStackView = BaseStackView(xPaddingCompact: 0.0)
    let propertiesHeaderView = SectionHeaderView(headerText: Localized("properties"))
    lazy var propertiesTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let firearmTypeCell = BaseTableViewCell(text: Localized("weapon_class"))
    let caliberCell = BaseTableViewCell(text: Localized("caliber"))
    let foldableCell = BaseTableViewCell(text: Localized("fold_or_retract"), accessory: .none, selection: .none)
    lazy var propertiesCells: [BaseTableViewCell] = { [firearmTypeCell, caliberCell, foldableCell] }()

    let performanceStackView = BaseStackView(xPaddingCompact: 0.0)
    let performanceHeaderView = SectionHeaderView(headerText: "performance".local())
    lazy var performanceTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let fireModesCell = BaseTableViewCell(text: Localized("fire_modes"), accessory: .none, selection: .none)
    let fireRateCell = BaseTableViewCell(text: Localized("fire_rate"), accessory: .none, selection: .none)
    let actionCell = BaseTableViewCell(text: Localized("action"), accessory: .none, selection: .none)
    let effectiveRangeCell = BaseTableViewCell(text: Localized("effective_range"), accessory: .none, selection: .none)
    lazy var performanceCells: [BaseTableViewCell] = {
        if firearm.fullAuto {
            return [fireModesCell, fireRateCell, effectiveRangeCell]
        } else if firearm.action == .other {
            return [fireModesCell, effectiveRangeCell]
        } else {
            return [actionCell, effectiveRangeCell]
        }
    }()

    let exploreStackView = BaseStackView(xPaddingCompact: 0.0)
    let exploreHeaderView = SectionHeaderView(headerText: "explore".local())
    lazy var exploreTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let compareCell = BaseTableViewCell(text: "compare_performance".local())
    let customBuildCell = BaseTableViewCell(text: "gun_build_custom".local())
    lazy var exploreCells: [BaseTableViewCell] = { return [compareCell, customBuildCell] }()

    init(_ firearm: Firearm) {
        self.firearm = firearm
        self.item = firearm

        super.init()

        propertiesStackView.addArrangedSubview(propertiesHeaderView)
        propertiesStackView.addArrangedSubview(propertiesTableView)

        performanceStackView.addArrangedSubview(performanceHeaderView)
        performanceStackView.addArrangedSubview(performanceTableView)

        exploreStackView.addArrangedSubview(exploreHeaderView)
        exploreStackView.addArrangedSubview(exploreTableView)

        firearmTypeCell.detailTextLabel?.text = firearm.firearmType.local()
        caliberCell.detailTextLabel?.text = firearm.caliber
        fireRateCell.detailTextLabel?.text = String(firearm.fireRate) + Localized("rpm")
        actionCell.detailTextLabel?.text = firearm.action != ActionType.other ? firearm.action.local(short: true) : nil
        effectiveRangeCell.detailTextLabel?.text = String(firearm.effectiveDistance) + Localized("meters_abbr")

        fireModesCell.detailTextLabel?.text = firearm.fireModesDisplayString()
        foldableCell.detailTextLabel?.text = Localized(firearm.foldableOrRetractable ? "yes" : "no")

        setupConstraints()
    }

    func setupConstraints() {
        let propertyTableViewHeight = CGFloat(propertiesCells.count) * propertiesTableView.rowHeight
        let totalPropertyStackHeight = propertiesHeaderView.height() + propertyTableViewHeight + propertiesStackView.totalPadding
        propertiesStackView.constrainHeight(totalPropertyStackHeight)

        let performanceTableViewHeight = CGFloat(performanceCells.count) * performanceTableView.rowHeight
        let totalPerformanceStackHeight: CGFloat = performanceHeaderView.height() + performanceTableViewHeight + performanceStackView.totalPadding
        performanceStackView.constrainHeight(totalPerformanceStackHeight)

        let exploreTableViewHeight = CGFloat(exploreCells.count) * exploreTableView.rowHeight
        let totalExploreStackHeight: CGFloat = exploreHeaderView.height() + exploreTableViewHeight + exploreStackView.totalPadding
        exploreStackView.constrainHeight(totalExploreStackHeight)
    }

    func getArrangedSubviews() -> [UIView] {
        return [propertiesStackView, performanceStackView, exploreStackView]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case propertiesTableView: return propertiesCells.count
        case performanceTableView: return performanceCells.count
        case exploreTableView: return exploreCells.count
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case propertiesTableView: return propertiesCells[indexPath.row]
        case performanceTableView: return performanceCells[indexPath.row]
        case exploreTableView: return exploreCells[indexPath.row]
        default: fatalError()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)

        let dbManager = DependencyManagerImpl.shared.databaseManager()

        switch cell {
        case firearmTypeCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllFirearmsOfType(type: firearm.firearmType) { firearms in
                self.delegate?.showLoading(show: false)

                let firearmTypeVC = BaseItemPreviewViewController(delegate: nil, config: FirearmPreviewConfiguration(items: firearms))
                firearmTypeVC.title = self.firearm.firearmType.local()
                self.delegate?.showViewController(viewController: firearmTypeVC)
            }
        case caliberCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllAmmoOfCaliber(caliber: firearm.caliber) { ammo in
                self.delegate?.showLoading(show: false)

                let ammoOfCaliberVC = BaseItemPreviewViewController(delegate: nil, config: AmmoPreviewConfiguration(items:ammo))
                ammoOfCaliberVC.title = self.firearm.caliber
                self.delegate?.showViewController(viewController: ammoOfCaliberVC)
            }
        case compareCell:
            self.delegate?.showLoading(show: true)

            dbManager.getAllFirearms { firearms in
                self.delegate?.showLoading(show: false)

                let comparisonVC = ComparisonOptionsViewController(FirearmComparison(self.firearm, allFirearms: firearms))
                self.delegate?.showViewController(viewController: comparisonVC)
            }
        case customBuildCell:
            self.delegate?.showLoading(show: true)

            let controller = FirearmBuildController(firearm)
            let buildVC = FirearmBuildViewController(controller)
            controller.loadBuildData { _ in
                self.delegate?.showLoading(show: false)
                self.delegate?.showViewController(viewController: buildVC)
            }
        default:
            fatalError()
        }
    }
}
