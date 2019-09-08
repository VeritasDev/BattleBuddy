//
//  ItemCompareViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class ItemCompareViewController: BaseTableViewController {
    var comparison: ItemComparison
    let comparisonCellReuseId = "ComparisonCell"

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ comparison: ItemComparison) {
        self.comparison = comparison

        super.init(style: .grouped)
    }

    override func viewDidLoad() {
         super.viewDidLoad()

        title = Localized("compare")

        tableView.register(ComparisonCell.self, forCellReuseIdentifier: comparisonCellReuseId)
        tableView.rowHeight = 34.0
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear
    }

    func didSelectItems(items: [Comparable]) {
        self.comparison.itemsBeingCompared = items
        tableView.reloadData()
        navigationController?.dismiss(animated: true)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return comparison.propertyOptions.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comparison.itemsBeingCompared.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return comparison.propertyOptions[section].local(short: false)
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let header = view as? UITableViewHeaderFooterView {
            header.textLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
            header.textLabel?.textColor = .white
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: comparisonCellReuseId, for: indexPath) as! ComparisonCell
        let item = comparison.itemsBeingCompared[indexPath.row]
        let property = comparison.propertyOptions[indexPath.section]
        let percent = comparison.getPercentValue(item: item, property: property, traitCollection: cell.traitCollection)
        let color = UIColor.scaledGradientColor(percent: Float(1.0 - (Float(indexPath.row + 1) / Float(comparison.itemsBeingCompared.count))))
        cell.update(keyColor: color, name: item.shortTitle, valueText: item.getValueStringForProperty(property), progressPercent: percent)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = comparison.itemsBeingCompared[indexPath.row]
        let itemDetailsConfig: ItemDetailsConfiguration

        switch item {
        case let firearm as Firearm: itemDetailsConfig = FirearmDetailsConfiguration(firearm)
        case let ammo as Ammo: itemDetailsConfig = AmmoDetailsConfiguration(ammo)
        case let armor as Armor: itemDetailsConfig = ArmorDetailsConfiguration(armor)
        case let med as Medical: itemDetailsConfig = MedicalDetailsConfiguration(med)
        case let throwable as Throwable: itemDetailsConfig = ThrowableDetailsConfiguration(throwable)
        case let melee as MeleeWeapon: itemDetailsConfig = MeleeWeaponDetailsConfiguration(melee)
        default: fatalError()
        }

        let detailsVC = ItemDetailsViewController(itemDetailsConfig)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}
