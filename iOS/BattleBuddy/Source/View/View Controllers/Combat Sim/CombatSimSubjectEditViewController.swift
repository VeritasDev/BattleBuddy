//
//  CombatSimSubjectEditViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/4/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

protocol SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewControllerDidCancel(_ subjectEditViewController: CombatSimSubjectEditViewController)
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing character: SimulationCharacter)
}

class CombatSimSubjectEditViewController: StaticGroupedTableViewController {
    let characters: [Character]
    var character: SimulationCharacter
    var firearmOptions: [SimulationFirearm]?
    var ammoOptions: [SimulationAmmo]?
    var armorOptions: [SimulationArmor]?
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
    let bodyArmorCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "body_armor".local())
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.italicSystemFont(ofSize: 14.0)
        return cell
    }()
    let headArmorCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_head_armor".local())
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
        return [GroupedTableViewSection(headerTitle: nil, cells: [subjectTypeCell, aimCell, firearmCell, ammoCell, headArmorCell, bodyArmorCell])]
    }

    func updateCells() {
        subjectTypeCell.detailTextLabel?.text = character.name
        aimCell.detailTextLabel?.text = character.aim.local()
        firearmCell.detailTextLabel?.text = character.firearm?.displayNameShort
        ammoCell.detailTextLabel?.text = character.ammo?.displayName
        headArmorCell.detailTextLabel?.text = character.headArmor?.displayName
        bodyArmorCell.detailTextLabel?.text = character.bodyArmor?.displayName
    }

    func showFirearmOptions() {
        if let options = firearmOptions {
            let selectFirearmVC = SortableTableViewController(selectionDelegate: self, config: FirearmSortConfig(options: options), currentSelection: character.firearm)
            selectFirearmVC.presentedModally = false
            navigationController?.pushViewController(selectFirearmVC, animated: true)
        } else {
            showLoading()

            dbManager.getAllFirearms { allFirearms in
                self.hideLoading()
                self.firearmOptions = allFirearms.compactMap { SimulationFirearm(json: $0.json) }
                self.showFirearmOptions()
            }
        }
    }

    func showArmorOptions(armorTypes: [ArmorType]) {
        if let options = armorOptions {
            let filteredOptions = options.filter { armorTypes.contains($0.armorType) }
            let currentSelection = armorTypes.contains(.body) ? character.bodyArmor : character.headArmor
            let selectArmorVC = SortableTableViewController(selectionDelegate: self, config: ArmorSortConfig(options: filteredOptions), currentSelection: currentSelection)
            selectArmorVC.presentedModally = false
            navigationController?.pushViewController(selectArmorVC, animated: true)
        } else {
            showLoading()

            dbManager.getAllArmor { allArmor in
                self.hideLoading()
                self.armorOptions = allArmor.compactMap { SimulationArmor(json: $0.json) }
                self.showArmorOptions(armorTypes: armorTypes)
            }
        }
    }

    func showAmmoOptions() {
        if character.firearm == nil { return }

        if let options = ammoOptions {
            let filteredOptions = options.filter{ $0.caliber == character.firearm?.caliber }
            let selectAmmoVC = SortableTableViewController(selectionDelegate: self, config: AmmoSortConfig(options: filteredOptions), currentSelection: character.ammo)
            selectAmmoVC.presentedModally = false
            navigationController?.pushViewController(selectAmmoVC, animated: true)
        } else {
            showLoading()

            dbManager.getAllAmmo { allAmmo in
                self.hideLoading()
                self.ammoOptions = allAmmo.compactMap { SimulationAmmo(json: $0.json) }
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
            let subjectTypeVC = SelectionViewController(self, title: "combat_sim_subject_type".local(), options: characters)
            subjectTypeVC.currentSelection = character
            navigationController?.pushViewController(subjectTypeVC, animated: true)
            break
        case aimCell:
            let aimVC = SelectionViewController(self, title: "combat_sim_aim_setting".local(), options: AimSetting.allCases)
            aimVC.currentSelection = character.aim
            navigationController?.pushViewController(aimVC, animated: true)
            break
        case firearmCell: showFirearmOptions()
        case headArmorCell: showArmorOptions(armorTypes: [.helmet, .attachment, .visor])
        case bodyArmorCell: showArmorOptions(armorTypes: [.body])
        case ammoCell: showAmmoOptions()
        default: break
        }
    }
}

extension CombatSimSubjectEditViewController: SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption) {
        switch selection {
        case let aimSelection as AimSetting:
            character.aim = aimSelection
        case let newCharacter as Character:
            let currentAimType = character.aim
            character = SimulationCharacter(json: newCharacter.json)!
            character.aim = currentAimType
        default:
            fatalError()
        }

        updateCells()
        navigationController?.popViewController(animated: true)
    }
}

extension CombatSimSubjectEditViewController: SortableItemSelectionDelegate {
    func itemSelected(_ selection: Sortable) {
        switch selection {
        case let firearmSelection as Firearm:
            if firearmSelection.caliber != character.ammo?.caliber {
                character.ammo = nil
            }

            character.firearm = SimulationFirearm(json: firearmSelection.json)
        case let ammoSelection as Ammo:
            character.ammo = SimulationAmmo(json: ammoSelection.json)
        case let armorSelection as Armor:
            if armorSelection.armorType == .body {
                character.bodyArmor = SimulationArmor(json: armorSelection.json)
            } else {
                character.headArmor = SimulationArmor(json: armorSelection.json)
            }
        default:
            fatalError()
        }

        updateCells()
        navigationController?.popViewController(animated: true)
    }

    func itemCleared(clearedSelection: Sortable) {
        switch clearedSelection {
        case _ as Firearm:
            character.ammo = nil
            character.firearm = nil
        case _ as Ammo:
            character.ammo = nil
        case let armorSelection as Armor:
            if armorSelection.armorType == .body {
                character.bodyArmor = nil
            } else {
                character.headArmor = nil
            }
        default:
            fatalError()
        }

        updateCells()
        navigationController?.popViewController(animated: true)
    }

    func selectionCancelled() {
        navigationController?.popViewController(animated: true)
    }
}
