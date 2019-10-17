//
//  CombatSimSubjectEditViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

protocol SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewControllerDidCancel(_ subjectEditViewController: CombatSimSubjectEditViewController)
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing character: SimulationCharacter)
}

class CombatSimSubjectEditViewController: StaticGroupedTableViewController {
    let characters: [Character]
    var character: SimulationCharacter
    var ammoOptions: [Ammo]?
    var armorOptions: [Armor]?
    let dbManager = dm().databaseManager()
    let subjectEditDelegate: SubjectEditViewControllerDelegate

    let subjectTypeCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_subject_type".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
    let aimCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_aim_setting".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
    let armorCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "armor".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
    let helmetCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "helmets".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
    let firearmCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "firearm".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
    let ammoCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "ammunition".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
//    lazy var subjectTypeSelectionViewController: SelectionViewController = {
//        return SelectionViewController(self, title: "combat_sim_subject_type".local(), options: characters)
//    }()
//    lazy var aimSettingSelectionViewController: SelectionViewController = {
//        return SelectionViewController(self, title: "combat_sim_aim_setting".local(), options: [AimSetting.centerOfMass, AimSetting.headshotsOnly, AimSetting.thoraxOnly, AimSetting.randomLegMeta, AimSetting.singleLegMeta])
//    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ subjectEditDelegate: SubjectEditViewControllerDelegate, characters: [Character], character: SimulationCharacter?) {
        guard let defaultCharacter = characters.first, let defaultSimChar = SimulationCharacter(json: defaultCharacter.json) else { fatalError() }

        self.subjectEditDelegate = subjectEditDelegate
        self.characters = characters
        self.character = character ?? defaultSimChar
        super.init()

        updateCells()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_subject".local()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func cancel() {
        subjectEditDelegate.combatSimSubjectEditViewControllerDidCancel(self)
    }

    @objc func save() {
        subjectEditDelegate.combatSimSubjectEditViewController(self, didFinishEditing: character)
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [GroupedTableViewSection(headerTitle: nil, cells: [subjectTypeCell, aimCell, armorCell, firearmCell, ammoCell])]
    }

    func updateCells() {
        subjectTypeCell.detailTextLabel?.text = character.name
        aimCell.detailTextLabel?.text = character.aim.local()
        armorCell.detailTextLabel?.text = character.armorSummary()
        firearmCell.detailTextLabel?.text = character.firearmSummary()
    }

    func showArmorOptions() {
        if let options = armorOptions {
            let selectArmorVC = SortableTableViewController(selectionDelegate: self, config: ArmorSortConfig(options: options), currentSelection: nil)
            navigationController?.pushViewController(selectArmorVC, animated: true)
        } else {
            showLoading()

            dbManager.getAllBodyArmor { allArmor in
                self.hideLoading()

                self.armorOptions = allArmor
                self.showArmorOptions()
            }
        }
    }

    func showAmmoOptions() {
        if let options = ammoOptions {
            let selectAmmoVC = SortableTableViewController(selectionDelegate: self, config: AmmoSortConfig(options: options), currentSelection: nil)
            navigationController?.pushViewController(selectAmmoVC, animated: true)
        } else {
            showLoading()

            dbManager.getAllAmmo { allAmmo in
                self.hideLoading()

                self.ammoOptions = allAmmo
                self.showAmmoOptions()
            }
        }
    }
}

// MARK: - Table view data source
extension CombatSimSubjectEditViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case subjectTypeCell:
//            subjectTypeSelectionViewController.currentSelection = character
//            navigationController?.pushViewController(subjectTypeSelectionViewController, animated: true)
            break
        case aimCell:
//            aimSettingSelectionViewController.currentSelection = subject.aim
//            navigationController?.pushViewController(aimSettingSelectionViewController, animated: true)
            break
        case firearmCell:
            let firearmEditVC = CombatSimFirearmEditViewController(character.firearm)
            navigationController?.pushViewController(firearmEditVC, animated: true)
            break
        case armorCell: showArmorOptions()
        case ammoCell: showAmmoOptions()
        default: break
        }
    }
}

extension CombatSimSubjectEditViewController: SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption) {
//        switch selectionViewController {
//        case subjectTypeSelectionViewController:
//            guard let character = selection as? Character else { fatalError() }
//            selectedCharacter = character
//            let newPerson = Person(selectedCharacter, aimSetting: subject.aim, armor: subject.equippedArmor, firearm: subject.firearmConfig)
//            subject = newPerson
//        case aimSettingSelectionViewController:
//            guard let aimSetting = selection as? AimSetting else { fatalError() }
//            subject.aim = aimSetting
//        default:
//            break
//        }
//
//        updateCells()
        navigationController?.popViewController(animated: true)
    }
}

extension CombatSimSubjectEditViewController: SortableItemSelectionDelegate {
    func itemSelected(_ selection: Sortable) {
        switch selection {
        case let selectedArmor as SimulationArmor: character.armor = [selectedArmor]
        default: fatalError()
        }

        updateCells()
        navigationController?.popViewController(animated: true)
    }

    func selectionCancelled() {
        navigationController?.popViewController(animated: true)
    }
}
