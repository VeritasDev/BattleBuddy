//
//  VeritasInfoViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/6/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SocialCell: BaseTableViewCell {
    let social: VeritasSocial

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ social: VeritasSocial) {
        self.social = social
        super.init(style: .subtitle, reuseIdentifier: nil)

        contentMode = .scaleAspectFit
        textLabel?.text = social.description()
        textLabel?.font = .systemFont(ofSize: 22.0)
        textLabel?.numberOfLines = 0
        imageView?.image = social.iconImage().imageScaled(toFit: CGSize(width: 33.0, height: 33.0))
        accessoryType = .disclosureIndicator
    }
}

class VeritasInfoViewController: BaseTableViewController {
    let twitchCell = SocialCell(.twitch)
    let youtubeCell = SocialCell(.youtube)
    let spotifyCell = SocialCell(.spotify)
    let twitterCell = SocialCell(.twitter)
    let discordCell = SocialCell(.discord)
    let instagramCell = SocialCell(.instagram)
    let soundcloudCell = SocialCell(.soundcloud)
    let websiteCell = SocialCell(.website)
    lazy var sections: [GroupedTableViewSection] = {
        let socialSection = GroupedTableViewSection(headerTitle: "social".local(), cells: [twitchCell, youtubeCell, twitterCell, discordCell, instagramCell, websiteCell])
        let musicSection = GroupedTableViewSection(headerTitle: "music".local(), cells: [spotifyCell, soundcloudCell])
        return [socialSection, musicSection]
    }()
    lazy var twitchManager = DependencyManagerImpl.shared.twitchManager

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "veritas".local()

        tableView.rowHeight = 60.0
    }

    override func viewWillAppear(_ animated: Bool) {
        if twitchManager.isChannelLive(.veritas) {
            twitchCell.detailTextLabel?.text = "live_now".local()
            twitchCell.detailTextLabel?.textColor = .red
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].headerTitle
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let socialCell = tableView.cellForRow(at: indexPath) as? SocialCell {
            handleLink(socialCell.social)
        }
    }
}
