//
//  FirearmBuildViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 9/25/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class FirearmBuildViewController: BaseTableViewController {
    var buildController: FirearmBuildController

    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    init(_ controller: FirearmBuildController) {
        buildController = controller
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = buildController.buildConfig.firearm.shortTitle
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return buildController.buildConfig.firearm.slots.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return buildController.buildConfig.firearm.slots[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
