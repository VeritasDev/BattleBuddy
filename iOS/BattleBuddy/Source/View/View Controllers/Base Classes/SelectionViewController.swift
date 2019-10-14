//
//  SelectionViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/11/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class SelectionOptionCell: BaseTableViewCell {
    static let reuseId: String = "SelectionOptionCell"
    var option: SelectionOption? {
        didSet {
            textLabel?.text = option?.optionTitle
            detailTextLabel?.text = option?.optionSubtitle
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(style: .subtitle, reuseIdentifier: SelectionOptionCell.reuseId)

        textLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        textLabel?.numberOfLines = 0
        detailTextLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.textColor = UIColor(white: 0.8, alpha: 1.0)
        selectionStyle = .gray
    }
}

class SelectionViewController: BaseTableViewController {
    let selectionDelegate: SelectionDelegate
    let options: [SelectionOption]
    let titleText: String
    var currentSelection: SelectionOption? {
        didSet {
            tableView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ selectionDelegate: SelectionDelegate, title: String, options: [SelectionOption]) {
        self.selectionDelegate = selectionDelegate
        self.options = options
        self.titleText = title
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = titleText
    }
}

// MARK: - Table view data source
extension SelectionViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionOptionCell.reuseId) as? SelectionOptionCell ?? SelectionOptionCell()
        let option = options[indexPath.row]
        let currentlySelected = currentSelection?.optionTitle == option.optionTitle
        cell.option = option
        cell.accessoryType = currentlySelected ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let selection = options[indexPath.row]
        selectionDelegate.selectionViewController(self, didMakeSelection: selection)
    }
}
