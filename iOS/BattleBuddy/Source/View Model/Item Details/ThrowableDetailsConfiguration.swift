//
//  ThrowableDetailsConfiguration.swift
//  BattleBuddy
//
//  Created by Mike on 7/17/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ThrowableDetailsConfiguration: NSObject, ItemDetailsConfiguration, UITableViewDelegate, UITableViewDataSource {
    var throwable: Throwable
    var item: BaseItem
    var delegate: ItemDetailsSectionDelegate?

    let propertiesStackView = BaseStackView(xPaddingCompact: 0.0)
    let propertiesHeaderView = SectionHeaderView(headerText: Localized("properties"))
    lazy var propertiesTableView = { BaseTableView(dataSource: self, delegate: self) }()
    let typeCell = BaseTableViewCell(text: Localized("type"), accessory: .none, selection: .none)
    let fuseTimeCell = BaseTableViewCell(text: Localized("fuse_time"), accessory: .none, selection: .none)
    let fragCountCell = BaseTableViewCell(text: Localized("fragmentation_count"), accessory: .none, selection: .none)
    let minRadiusCell = BaseTableViewCell(text: Localized("explosion_radius_min"), accessory: .none, selection: .none)
    let maxRadiusCell = BaseTableViewCell(text: Localized("explosion_radius_max"), accessory: .none, selection: .none)
    let compareCell = BaseTableViewCell(text: Localized("compare"))
    lazy var propertiesCells: [BaseTableViewCell] = {
        if throwable.throwableType == .frag {
            return [typeCell, fuseTimeCell, fragCountCell, minRadiusCell, maxRadiusCell, compareCell]
        } else {
            return [typeCell, fuseTimeCell, compareCell]
        }
    }()

    init(_ throwable: Throwable) {
        self.throwable = throwable
        self.item = throwable

        super.init()

        propertiesStackView.addArrangedSubview(propertiesHeaderView)
        propertiesStackView.addArrangedSubview(propertiesTableView)

        typeCell.detailTextLabel?.text = throwable.throwableType.local()
        fuseTimeCell.detailTextLabel?.text = String(throwable.fuseTime) + Localized("seconds_abbr")
        fragCountCell.detailTextLabel?.text = String(throwable.fragmentationCount)
        minRadiusCell.detailTextLabel?.text = String(throwable.explosionRadiusMin) + Localized("meters_abbr")
        maxRadiusCell.detailTextLabel?.text = String(throwable.explosionRadiusMax) + Localized("meters_abbr")

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

            dbManager.getAllThrowables { throwables in
                self.delegate?.showLoading(show: false)
                self.delegate?.showViewController(viewController: ComparisonOptionsViewController(ThrowableComparison(throwables)))
            }
        default: fatalError()
        }
    }
}
