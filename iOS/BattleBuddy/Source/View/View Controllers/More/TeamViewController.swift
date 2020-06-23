//
//  TeamViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/7/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class TwitchCell: BaseTableViewCell {
    let channel: TwitchChannel
    var isLive: Bool = false {
        didSet {
            detailTextLabel?.text = isLive ? "live_now".local() : nil
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ channel: TwitchChannel) {
        self.channel = channel
        super.init(style: .value1, reuseIdentifier: nil)

        contentMode = .scaleAspectFit
        imageView?.image = channel.iconImage().imageScaled(toFit: CGSize(width: 45.0, height: 45.0))
        textLabel?.text = channel.name()
        textLabel?.font = .systemFont(ofSize: 22.0, weight: .semibold)
        detailTextLabel?.textColor = .red
        accessoryType = .disclosureIndicator
    }
}

class TeamViewController: BaseTableViewController {
    let veritasCell = TwitchCell(.veritas)
    let ghostfreakCell = TwitchCell(.ghostfreak)
    let slushCell = TwitchCell(.slushpuppy)
    let pestilyCell = TwitchCell(.pestily)
    let antonCell = TwitchCell(.anton)
    let sigmaCell = TwitchCell(.sigma)
    lazy var teamCells: [TwitchCell] = [ghostfreakCell, slushCell, pestilyCell, antonCell, sigmaCell, veritasCell]
    lazy var twitchManager = DependencyManagerImpl.shared.twitchManager()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = UIImageView(image: UIImage(named: "team_title")!)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        navigationItem.largeTitleDisplayMode = .never

        tableView.rowHeight = 70.0
    }

    override func viewWillAppear(_ animated: Bool) {
        for cell in teamCells {
            cell.isLive = twitchManager.isChannelLive(cell.channel)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return teamCells.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return teamCells[indexPath.section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let cell = tableView.cellForRow(at: indexPath) as? TwitchCell {
            handleLink(cell.channel)
        }
    }
}
