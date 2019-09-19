//
//  LeaderboardViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class LeaderboardViewController: BaseTableViewController {
    let leaderboard: [BBUser]

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ leaderboard: [BBUser]) {
        self.leaderboard = leaderboard
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "leaderboard".local()

        tableView.rowHeight = 55.0
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leaderboard.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: LeaderboardCell.leaderboardCellReuseId) ?? LeaderboardCell()) as! LeaderboardCell
        let row = indexPath.row
        cell.rank = row + 1
        cell.user = leaderboard[row]
        return cell
    }
}
