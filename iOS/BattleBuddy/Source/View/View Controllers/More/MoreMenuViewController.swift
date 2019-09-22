//
//  MoreMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class MoreMenuViewController: BaseTableViewController, AdDelegate {
    static let iconHeight: CGFloat = 40.0
    var adManager = DependencyManagerImpl.shared.adManager()
    let feedbackManager = DependencyManagerImpl.shared.feedbackManager()
    var userCount = 0
    let globalMetadataManager: GlobalMetadataManager = DependencyManagerImpl.shared.metadataManager()
    var globalMetadata: GlobalMetadata?

    let veritasCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "dev_by".local()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.imageView?.image = UIImage(named: "veritas")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let githubCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "view_on_github".local()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.imageView?.image = UIImage(named: "github")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight)).withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .white
        cell.height = 70.0
        return cell
    }()
    let attributionsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "attributions".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "attributions")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let daysSinceWipeCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        cell.imageView?.image = UIImage(named: "wipe")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let userCountCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        cell.imageView?.image = UIImage(named: "user_count")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let settingsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "settings".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "settings")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let leaderboardCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.text = "supporter_leaderboard".local()
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "trophy")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let rateCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "rate_this_app".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "seems_good")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let theTeamCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "check_out_team".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "team_logo")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let watchAdCell: WatchAdCell = WatchAdCell(iconHeight: iconHeight)
    let feedbackCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.imageView?.image = UIImage(named: "discord")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.textLabel?.text = "feedback_title".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = "feedback_subtitle".local()
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .gray
        return cell
    }()
    var sections: [GroupedTableViewSection] = []
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

        adManager.adDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "more".local()
        adManager.loadVideoAd()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        globalMetadata = globalMetadataManager.getGlobalMetadata()
        updateCells()
    }

    func updateCells() {
        sections = []

        let aboutCells = [settingsCell, veritasCell, githubCell, attributionsCell]
        let aboutSection = GroupedTableViewSection(headerTitle: "about".local(), cells: aboutCells)
        sections.append(aboutSection)

        if let metaData = globalMetadata {
            let dateDifference = Date().timeIntervalSince(metaData.lastWipeDate)
            let daysSinceWipe = ceil(dateDifference / 86_400)
            let dayCountString = String(Int(daysSinceWipe))
            let daysSinceWipeString =  "days_since_wipe".local(args: [dayCountString])
            daysSinceWipeCell.textLabel?.attributedText = daysSinceWipeString.createAttributedString(boldedSubstring: dayCountString, font: .systemFont(ofSize: 20, weight: .light))

            userCount = metaData.totalUserCount

            let userCountString = numberFormatter.string(from: NSNumber(value: userCount)) ?? String(userCount)
            let fullUsersString = "total_users_count".local(args: [userCountString])
            userCountCell.textLabel?.attributedText = fullUsersString.createAttributedString(boldedSubstring: userCountString, font: .systemFont(ofSize: 18, weight: .light))

            let statsCells = [daysSinceWipeCell, userCountCell, leaderboardCell]
            let globalStatsSection = GroupedTableViewSection(headerTitle: "global_stats".local(), cells: statsCells)
            sections.append(globalStatsSection)
        }

        watchAdCell.videoAdState = adManager.currentVideoAdState

        let appVersion = DependencyManagerImpl.shared.deviceManager().appVersionString()
        let supportCells = feedbackManager.canAskForReview() ? [rateCell, feedbackCell, theTeamCell, watchAdCell] : [feedbackCell, theTeamCell, watchAdCell]
        let supportSection = GroupedTableViewSection(headerTitle: "dev_support".local(), footerTitle: appVersion, cells: supportCells)
        sections.append(supportSection)
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)

        switch cell {
        case settingsCell: navigationController?.pushViewController(SettingsViewController(), animated: true)
        case veritasCell: navigationController?.pushViewController(VeritasInfoViewController(), animated: true)
        case githubCell: handleLink(VeritasSocial.github)
        case attributionsCell: navigationController?.pushViewController(AttributionsViewController(), animated: true)
        case feedbackCell: handleLink(VeritasSocial.discord)
        case watchAdCell: adManager.watchAdVideo(from: self)
        case theTeamCell: navigationController?.pushViewController(TeamViewController(), animated: true)
        case rateCell: feedbackManager.askForReview()
        case leaderboardCell: navigationController?.pushViewController(LeaderboardViewController(globalMetadata!.loyaltyLeaderboard), animated: true)
        default: break
        }
    }

    func adManager(_ adManager: AdManager, didUpdate videoAdState: VideoAdState) {
        watchAdCell.videoAdState = videoAdState
    }
}
