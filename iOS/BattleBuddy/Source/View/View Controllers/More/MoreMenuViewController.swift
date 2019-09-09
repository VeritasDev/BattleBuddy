//
//  MoreMenuViewController.swift
//  BattleBuddy
//
//  Created by Mike on 6/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

struct GroupedTableViewSection {
    let headerTitle: String?
    let footerTitle: String?
    let cells: [UITableViewCell]

    init(headerTitle: String?, footerTitle: String? = nil, cells: [UITableViewCell]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.cells = cells
    }
}

class MoreMenuViewController: BaseTableViewController, AdDelegate {
    static let iconHeight: CGFloat = 40.0
    var adManager = DependencyManagerImpl.shared.adManager()
    let feedbackManager = DependencyManagerImpl.shared.feedbackManager()
    var userCount = 0

    let veritasCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "dev_by".local()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.imageView?.image = UIImage(named: "veritas")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        return cell
    }()
    let upcomingFeaturesCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "upcoming_features".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "calendar")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        return cell
    }()
    let githubCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "view_on_github".local()
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.imageView?.image = UIImage(named: "github")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight)).withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = .white
        return cell
    }()
    let attributionsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "attributions".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "attributions")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        return cell
    }()
    let userCountCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle = .none
        cell.isUserInteractionEnabled = false
        cell.imageView?.image = UIImage(named: "user_count")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        return cell
    }()

    let rateCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "rate_this_app".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "seems_good")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        return cell
    }()
    let theTeamCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "check_out_team".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryType = .disclosureIndicator
        cell.imageView?.image = UIImage(named: "team_logo")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))
        return cell
    }()
    lazy var enableBannerAdsCell: BaseTableViewCell = {
        let cell = BaseTableViewCell()
        cell.textLabel?.text = "enable_banner_ads".local()
        cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        cell.accessoryView = {
            let toggle = UISwitch()
            toggle.setOn(adManager.bannerAdsEnabled(), animated: false)
            toggle.addTarget(self, action: #selector(toggleBannerAds(sender:)), for: .valueChanged)
            return toggle
        }()
        cell.selectionStyle = .none
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
        tableView.rowHeight = 70.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "more".local()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateCells()
    }

    func updateCells() {
        userCount = DependencyManagerImpl.shared.metadataManager().getGlobalMetadata()?.totalUserCount ?? 0
        if userCount > 0,
            let numberString = numberFormatter.string(from: NSNumber(value: userCount)) {
            let fullString = "total_users_count".local(args: [numberString])
            userCountCell.textLabel?.attributedText = fullString.createAttributedString(boldedSubstring: numberString, font: .systemFont(ofSize: 18, weight: .light))
        } else {
            userCountCell.textLabel?.text = nil
        }

        let appVersion = DependencyManagerImpl.shared.deviceManager().appVersionString()
        let aboutCells = userCount > 0 ? [veritasCell, upcomingFeaturesCell, githubCell, attributionsCell, userCountCell] : [veritasCell, upcomingFeaturesCell, githubCell, attributionsCell]
        let aboutSection = GroupedTableViewSection(headerTitle: "about".local(), cells: aboutCells)
        let supportCells = feedbackManager.canAskForReview() ? [rateCell, feedbackCell, theTeamCell, watchAdCell] : [feedbackCell, theTeamCell, watchAdCell]
        let supportSection = GroupedTableViewSection(headerTitle: "dev_support".local(), footerTitle: appVersion, cells: supportCells)
        sections = [aboutSection, supportSection]
        tableView.reloadData()
    }

    @objc func toggleBannerAds(sender: UISwitch) {
        let adsEnabled = sender.isOn
        adManager.updateBannerAdsSetting(adsEnabled)
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

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)

        switch cell {
        case veritasCell: navigationController?.pushViewController(VeritasInfoViewController(), animated: true)
        case upcomingFeaturesCell: navigationController?.pushViewController(PostViewController(UpcomingFeaturesPost()), animated: true)
        case githubCell: handleLink(VeritasSocial.github)
        case attributionsCell: navigationController?.pushViewController(AttributionsViewController(), animated: true)
        case feedbackCell: handleLink(VeritasSocial.discord)
        case watchAdCell: adManager.watchAdVideo(from: self)
        case theTeamCell: navigationController?.pushViewController(TeamViewController(), animated: true)
        case rateCell: feedbackManager.askForReview()
        default: break
        }
    }

    func adManager(_ adManager: AdManager, didUpdate videoAdState: VideoAdState) {
        watchAdCell.videoAdState = videoAdState
    }
}
