//
//  SettingsViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/14/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

// TODO:
// - Push notifications
// - Nickname
// - Banner ads
class SettingsViewController: BaseTableViewController {
    let prefsManager = dm().prefsManager()
    let localeManager = dm().localeManager()
    var sections: [GroupedTableViewSection] = []

    lazy var languageCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "language".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 18.0)
        cell.accessoryType = .disclosureIndicator
        cell.height = 70.0
        return cell
    }()
//    lazy var enableBannerAdsCell: BaseTableViewCell = {
//        let cell = BaseTableViewCell()
//        cell.textLabel?.text = "enable_banner_ads".local()
//        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
//        cell.accessoryView = {
//            let toggle = UISwitch()
//            toggle.setOn(adManager.bannerAdsEnabled(), animated: false)
//            toggle.addTarget(self, action: #selector(toggleBannerAds(sender:)), for: .valueChanged)
//            return toggle
//        }()
//        cell.selectionStyle = .none
//        return cell
//    }()
//
//
//    @objc func toggleBannerAds(sender: UISwitch) {
//        let adsEnabled = sender.isOn
//        adManager.updateBannerAdsSetting(adsEnabled)
//    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "settings".local()
    }

    override func viewWillAppear(_ animated: Bool) {
        updateCells()
    }

    func updateCells() {
        languageCell.detailTextLabel?.text = localeManager.currentLanguageDisplayName()

        sections = [GroupedTableViewSection(headerTitle: nil, cells: [languageCell])]
        tableView.reloadData()
    }

    // MARK: - Table view data source
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

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case languageCell: navigationController?.pushViewController(LanguageSelectionViewController(), animated: true)
        default: break;
        }
    }
}
