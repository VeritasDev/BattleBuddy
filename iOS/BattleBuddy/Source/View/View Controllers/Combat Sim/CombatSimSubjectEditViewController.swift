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
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing subject: Person)
}

class CombatSimSubjectEditViewController: StaticGroupedTableViewController {
    var subject: Person
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
    lazy var subjectTypeSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, title: "combat_sim_subject_type".local(), options: [PersonType.pmc, PersonType.scav, PersonType.raider, PersonType.killa, PersonType.dealmaker, PersonType.dealmakerFollower])
    }()
    lazy var aimSettingSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, title: "combat_sim_aim_setting".local(), options: [AimSetting.centerOfMass, AimSetting.headshotsOnly, AimSetting.thoraxOnly, AimSetting.randomLegMeta, AimSetting.singleLegMeta])
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ subjectEditDelegate: SubjectEditViewControllerDelegate, person: Person) {
        self.subjectEditDelegate = subjectEditDelegate
        self.subject = person
        super.init()

        updateCells()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_subject".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func save() {
        subjectEditDelegate.combatSimSubjectEditViewController(self, didFinishEditing: subject)
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [GroupedTableViewSection(headerTitle: nil, cells: [subjectTypeCell, aimCell, armorCell, firearmCell, ammoCell])]
    }

    func updateCells() {
        subjectTypeCell.detailTextLabel?.text = subject.type.local()
        aimCell.detailTextLabel?.text = subject.aim.local()
        armorCell.detailTextLabel?.text = subject.equippedArmor.isEmpty ? "common_none".local() : subject.equippedArmor.compactMap{$0.resolvedArmorName}.joined(separator: ", ")
        firearmCell.detailTextLabel?.text = subject.firearmConfig.name
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
            subjectTypeSelectionViewController.currentSelection = subject.type
            navigationController?.pushViewController(subjectTypeSelectionViewController, animated: true)
        case aimCell:
            aimSettingSelectionViewController.currentSelection = subject.aim
            navigationController?.pushViewController(aimSettingSelectionViewController, animated: true)
        case firearmCell:
            break
        case armorCell: showArmorOptions()
        case armorCell: showAmmoOptions()
        default: break
        }
    }
}

extension CombatSimSubjectEditViewController: SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption) {
        switch selectionViewController {
        case subjectTypeSelectionViewController:
            guard let personType = selection as? PersonType else { fatalError() }
            let newPerson = Person(personType, aimSetting: subject.aim, armor: subject.equippedArmor, firearm: subject.firearmConfig)
            subject = newPerson
        case aimSettingSelectionViewController:
            guard let aimSetting = selection as? AimSetting else { fatalError() }
            subject.aim = aimSetting
        default:
            break
        }

        updateCells()
        navigationController?.popViewController(animated: true)
    }
}

extension CombatSimSubjectEditViewController: SortableItemSelectionDelegate {
    func itemSelected(_ selection: Sortable) {
        switch selection {
        case let selectedArmor as Armor: subject.equippedArmor = [selectedArmor]
        case let selectedAmmo as Ammo: subject.firearmConfig.ammoConfiguration = [selectedAmmo]
        default: fatalError()
        }

        navigationController?.popViewController(animated: true)
    }

    func selectionCancelled() {
        navigationController?.popViewController(animated: true)
    }
}
