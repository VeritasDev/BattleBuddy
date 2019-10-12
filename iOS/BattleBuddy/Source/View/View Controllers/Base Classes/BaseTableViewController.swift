//
//  BaseTableViewController.swift
//  BattleBuddy
//
//  Created by Mike on 8/24/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseTableViewController: UITableViewController {
    let hud = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.Theme.background
        tableView.separatorColor = UIColor(white: 0.4, alpha: 1.0)
    }

    func showLoading() {
        hud.show(in: self.view)
    }

    func hideLoading() {
        hud.dismiss(animated: false)
    }
}

protocol StaticGroupedTableViewDelegate {
    func handleCellSelected(_ cell: BaseTableViewCell)
}

class StaticGroupedTableViewController: BaseTableViewController, StaticGroupedTableViewDelegate {
    lazy var staticTableViewDelegate: StaticGroupedTableViewDelegate = self
    lazy var sections: [GroupedTableViewSection] = { return generateSections() }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(style: .grouped)
    }

    func generateSections() -> [GroupedTableViewSection] {
        return []
    }

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
        let cell = sections[indexPath.section].cells[indexPath.row]
        self.staticTableViewDelegate.handleCellSelected(cell)
    }

    func handleCellSelected(_ cell: BaseTableViewCell) {

    }
}
