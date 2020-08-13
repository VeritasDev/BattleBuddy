//
//  MoreMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SupportViewController: BaseTableViewController {
    let iapManager: IAPManager = dm().iapManager()

    lazy var sections: [GroupedTableViewSection] = {
        var cells: [BaseTableViewCell] = []
        for product in self.iapManager.getProducts() {
            let optionCell: BaseTableViewCell = {
                let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
                cell.textLabel?.text = product.localizedTitle
                cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
                cell.textLabel?.numberOfLines = 0
                cell.selectionStyle = .gray
                cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .regular)
                cell.detailTextLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = product.localizedDescription
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .gray
                return cell
            }()
            cells.append(optionCell)
        }
        return [GroupedTableViewSection(headerTitle: "supporter_subtitle".local(), footerTitle: nil, cells: cells)]
    }()
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .decimal
        formatter.generatesDecimalNumbers = false
        return formatter
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "supporter_title".local()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Table view data source
extension SupportViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].cells[indexPath.row].height
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
    }
}
