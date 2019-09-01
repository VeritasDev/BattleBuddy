//
//  FirearmBuildViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/10/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

/*
class FirearmBuildViewController: UITableViewController, CompatibleItemSelectionDelegate {
    let firearmBuild: FirearmBuild

    required init?(coder: NSCoder) { fatalError() }

    init(firearm: Firearm, preset: FirearmBuildPreset) {
        self.firearmBuild = FirearmBuild(firearm: firearm, preset: preset)

        super.init(style: .grouped)

        title = Localized("build") + " - " + firearm.displayNameShort
        tableView.rowHeight = UITableView.automaticDimension
    }

    // Compatible item selection delegate

    func itemSelectedForSlot(_ slot: ModdableSlot, item: ModdableMod) {
        let conflict = firearmBuild.slotConflictingWithCandidateMod(mod: item, toSlot: slot)

        if let conflict = conflict,
            let attachedMod = conflict.attachedMod {
            print("\(attachedMod.itemName) conflicts with \(item.itemName)")
        } else {
            firearmBuild.add(mod: item, toSlot: slot)
            tableView.reloadData()
            navigationController?.popViewController(animated: true)
        }
    }

    func removeItemForSlot(_ slot: ModdableSlot) {
        firearmBuild.removeMod(fromSlot: slot)
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firearmBuild.flattenedSlots().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FirearmBuildSlotCell.reuseId) as? FirearmBuildSlotCell ?? FirearmBuildSlotCell()
        cell.slot = firearmBuild.flattenedSlots()[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedSlot = firearmBuild.flattenedSlots()[indexPath.row]
        let items = firearmBuild.getCompatibleItems(slot: selectedSlot)
        let selectModVC = CompatibleItemsViewController(selectionDelegate: self, slot: selectedSlot, items: items)
        navigationController?.pushViewController(selectModVC, animated: true)
    }

}
 */
