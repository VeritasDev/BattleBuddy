//
//  MoreMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class MoreMenuViewController: BaseTableViewController {
    static let iconHeight: CGFloat = 40.0
    let feedbackManager = dm().feedbackManager()
    let accountManager = dm().accountManager()
    let globalMetadataManager: GlobalMetadataManager = dm().metadataManager()
    let iapManager: IAPManager = dm().iapManager()
    var globalMetadata: GlobalMetadata?
    var currentUserMetadata: BBUser?
    var userCount = 0

    let newsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "battle_buddy_news".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "battle_buddy_news")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
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
    let versionCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .value1, text: "app_version".local(), detailText: nil, accessory: .none, selection: .none)
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: "app_version")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 18.0)
        cell.height = 70.0
        return cell
    }()
    let budScoreCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .value1, text: "your_bud_score".local(), detailText: nil)
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: "your_bud_score")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.height = 70.0
        return cell
    }()
    let rewardCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .value1, text: "bud_reward".local(), detailText: nil)
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image = UIImage(named: "reward")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
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
        cell.textLabel?.text = "bud_leaderboard".local()
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
    let bsgTwitterCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "attributions_bsg".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "twitter")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.height = 70.0
        return cell
    }()
    let supportCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.imageView?.image = UIImage(named: "supporter")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        cell.textLabel?.text = "supporter_title".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .gray
        cell.accessoryType = .disclosureIndicator
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
    lazy var updateTimer: Timer? = {
        return Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { _ in
            self.globalMetadataManager.updateGlobalMetadata { updatedMeta in
                self.globalMetadata = updatedMeta

                self.accountManager.refreshUserMetadata { updatedUser in
                    self.currentUserMetadata = updatedUser

                    self.tableView.reloadData()
                }
            }
        }
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "more".local()

        startUpdateTimer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        globalMetadata = globalMetadataManager.getGlobalMetadata()
        updateCells()
    }

    func startUpdateTimer() {
        updateTimer?.fire()
    }

    func updateCells() {
        sections = []
        currentUserMetadata = accountManager.currentUserMetadata()

        versionCell.detailTextLabel?.text = DependencyManagerImpl.shared.deviceManager().appVersionString()
        let aboutCells = [settingsCell, versionCell, veritasCell]
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

            let nextAvailableReward = accountManager.nextAvailableBudPointsReward()
            if nextAvailableReward.redeemable {
                rewardCell.contentView.alpha = 1.0
                rewardCell.isUserInteractionEnabled = true
            } else {
                rewardCell.contentView.alpha = 0.3
                rewardCell.isUserInteractionEnabled = false
            }

            rewardCell.detailTextLabel?.text = String(nextAvailableReward.points)

            let statsCells = [userCountCell, daysSinceWipeCell, bsgTwitterCell]
            let globalStatsSection = GroupedTableViewSection(headerTitle: "global_stats".local(), cells: statsCells)
            sections.append(globalStatsSection)
        }

        if let currentUserData = currentUserMetadata {
            budScoreCell.detailTextLabel?.text = currentUserData.loyalty.stringValue
        }


        let supportCells = feedbackManager.canAskForReview() ? [supportCell, rateCell, feedbackCell, githubCell, theTeamCell, attributionsCell] : [supportCell, feedbackCell, githubCell, theTeamCell, attributionsCell]
        let supportSection = GroupedTableViewSection(headerTitle: "dev_support".local(), cells: supportCells)
        sections.append(supportSection)
        tableView.reloadData()
    }

    func earnReward() {
        showLoading()

        accountManager.redeemBudPoints {
            self.hideLoading()
            self.updateCells()
            self.showAlert(title: "bud_reward_title".local(), message: "bud_reward_message".local())
        }
    }
}

// MARK: - Table view data source
extension MoreMenuViewController {
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
//        case newsCell: navigationController?.pushViewController(PostViewController(NewsPost()), animated: true)
        case settingsCell: navigationController?.pushViewController(SettingsViewController(), animated: true)
        case veritasCell: navigationController?.pushViewController(VeritasInfoViewController(), animated: true)
        case githubCell: handleLink(VeritasSocial.github)
        case attributionsCell: navigationController?.pushViewController(AttributionsViewController(), animated: true)
        case feedbackCell: handleLink(VeritasSocial.discord)
        case theTeamCell: navigationController?.pushViewController(TeamViewController(), animated: true)
        case rateCell: feedbackManager.askForReview()
        case leaderboardCell: navigationController?.pushViewController(LeaderboardViewController(globalMetadata!.loyaltyLeaderboard), animated: true)
        case budScoreCell: navigationController?.pushViewController(PostViewController(BudPost()), animated: true)
        case rewardCell: earnReward()
        case bsgTwitterCell: navigationController?.pushViewController(BattlestateTwitterViewController(), animated: true)
        case supportCell: navigationController?.pushViewController(SupportViewController(), animated: true)
        default: break
        }
    }
}
