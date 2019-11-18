//
//  AttributionsViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class AttributionsViewController: BaseTableViewController {
    lazy var restApiCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_api".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_api_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    lazy var nofamCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_nofam".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_nofam_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    lazy var willerzCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_willerz".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_willerz_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    lazy var communityCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_community".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_community_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.isUserInteractionEnabled = false
        return cell
    }()
    lazy var bsgCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_bsg".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_bsg_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    lazy var betrixCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_betrix".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_betrix_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.isUserInteractionEnabled = false
        return cell
    }()
    lazy var smooothCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_smoooth".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_smoooth_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    lazy var translationsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_translations".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_translations_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .light)
        cell.detailTextLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    lazy var miscCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = "attributions_misc".local()
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "attributions_misc_descr".local()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        cell.detailTextLabel?.numberOfLines = 0
        cell.isUserInteractionEnabled = false
        return cell
    }()

    lazy var cells: [BaseTableViewCell] = [bsgCell, restApiCell, nofamCell, smooothCell, willerzCell, translationsCell, betrixCell, communityCell, miscCell]

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "attributions".local()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case restApiCell: handleUrlString("https://tarkov-database.com/about")
        case nofamCell: handleUrlString("https://www.twitch.tv/nofoodaftermidnight")
        case willerzCell: handleUrlString("https://www.twitch.tv/willer_z")
        case bsgCell: handleUrlString("https://www.battlestategames.com/")
        case smooothCell: handleUrlString("https://www.twitch.tv/smooothbrain")
        case translationsCell: navigationController?.pushViewController(LocalizationTeamViewController(), animated: true)
        default: break
        }
    }
}
