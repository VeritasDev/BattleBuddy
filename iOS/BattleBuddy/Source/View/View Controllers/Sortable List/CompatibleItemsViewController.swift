//
//  CompatibleItemsViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/10/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol CompatibleItemSelectionDelegate {
    func itemSelectedForSlot(_ slot: ModdableSlot, item: ModdableMod)
    func removeItemForSlot(_ slot: ModdableSlot)
}

class CompatibleItemsViewController: UITableViewController, CompatibleModsHeaderViewDelegate {
    let cellReuseId: String = "CompatibleItemCell"
    let selectionDelegate: CompatibleItemSelectionDelegate
    let slot: ModdableSlot
    var items: [ModdableMod]
    lazy var header: CompatibleModsHeaderView = { CompatibleModsHeaderView(delegate: self) }()

    required init?(coder: NSCoder) { fatalError() }

    init(selectionDelegate: CompatibleItemSelectionDelegate, slot: ModdableSlot, items: [ModdableMod]) {
        self.selectionDelegate = selectionDelegate
        self.slot = slot
        self.items = items
        self.items.sort { $0.ergo > $1.ergo }
        super.init(style: .plain)

        navigationItem.rightBarButtonItem = slot.attachedMod != nil ? UIBarButtonItem.init(title: Localized("Remove"), style: .plain, target: self, action: #selector(handleRemove)) : nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = slot.local()

        tableView.tableFooterView = UIView()
    }

    @objc func handleRemove() {
        self.selectionDelegate.removeItemForSlot(slot)
    }


    func sortByRecoil() {
        items.sort { $0.recoil < $1.recoil }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    func sortByErgo() {
        items.sort { $0.ergo > $1.ergo }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return header
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50.0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) ?? CompatibleModStatsCell()
        guard let modCell = cell as? CompatibleModStatsCell else { fatalError() }
        let mod = items[indexPath.row]
        modCell.mod = mod
        if let attachedMod = self.slot.attachedMod {
            modCell.isSelected = (attachedMod == mod)
        } else {
            modCell.isSelected = false
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectionDelegate.itemSelectedForSlot(slot, item: items[indexPath.row])
    }
}
