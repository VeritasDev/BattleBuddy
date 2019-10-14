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
    var person: Person
    lazy var subjectTypeSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, title: "combat_sim_subject_type".local(), options: [PersonType.pmc, PersonType.scav, PersonType.raider, PersonType.killa, PersonType.dealmaker, PersonType.dealmakerFollower])
    }()
    lazy var aimSettingSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, title: "combat_sim_aim_setting".local(), options: [AimSetting.centerOfMass, AimSetting.headshotsOnly, AimSetting.thoraxOnly, AimSetting.randomLegMeta, AimSetting.singleLegMeta])
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ subjectEditDelegate: SubjectEditViewControllerDelegate, person: Person) {
        self.subjectEditDelegate = subjectEditDelegate
        self.person = person
        super.init()

        updateCells()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_subject".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func save() {
        subjectEditDelegate.combatSimSubjectEditViewController(self, didFinishEditing: person)
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [GroupedTableViewSection(headerTitle: nil, cells: [subjectTypeCell, aimCell, firearmCell])]
    }

    func updateCells() {
        subjectTypeCell.detailTextLabel?.text = person.type.local()
        aimCell.detailTextLabel?.text = person.aim.local()
        armorCell.detailTextLabel?.text = person.equippedArmor.isEmpty ? "common_none".local() : person.equippedArmor.compactMap{$0.resolvedArmorName}.joined(separator: ", ")
        firearmCell.detailTextLabel?.text = person.firearmConfig.name
    }
}

// MARK: - Table view data source
extension CombatSimSubjectEditViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case subjectTypeCell:
            subjectTypeSelectionViewController.currentSelection = person.type
            navigationController?.pushViewController(subjectTypeSelectionViewController, animated: true)
        case aimCell:
            aimSettingSelectionViewController.currentSelection = person.aim
            navigationController?.pushViewController(aimSettingSelectionViewController, animated: true)
        default: break
        }
    }
}

extension CombatSimSubjectEditViewController: SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption) {
        switch selectionViewController {
        case subjectTypeSelectionViewController:
            guard let personType = selection as? PersonType else { fatalError() }
            let newPerson = Person(personType, aimSetting: person.aim, armor: person.equippedArmor, firearm: person.firearmConfig)
            person = newPerson
        case aimSettingSelectionViewController:
            guard let aimSetting = selection as? AimSetting else { fatalError() }
            person.aim = aimSetting
        default:
            break
        }

        updateCells()
        navigationController?.popViewController(animated: true)
    }
}
