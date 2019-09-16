//
//  PostViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/13/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class PostViewController: BaseTableViewController {
    let config: PostConfiguration
    let cells: [PostElementCell]

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ postConfig: PostConfiguration) {
        config = postConfig
        cells = config.elements.map { PostElementCell($0) }

        super.init(style: .plain)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = config.title
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorColor = .clear
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let element = config.elements[indexPath.row]
        switch element.type {
        case .youtube, .image: return tableView.frame.width * 0.56
        default: return UITableView.automaticDimension
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
}
