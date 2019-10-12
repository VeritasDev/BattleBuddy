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
        return cell
    }()
    let aimCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "combat_sim_aim_setting".local())
        return cell
    }()
    let firearmCell: BaseTableViewCell = {
        let cell = BaseTableViewCell(text: "firearm".local())
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_subject".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    @objc func save() {
        // TODO: Gather data from UI and package into Person
        let person = Person(.dealmaker, aimSetting: .centerOfMass, armor: [], firearm: nil)
        subjectEditDelegate.combatSimSubjectEditViewController(self, didFinishEditing: person)
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [GroupedTableViewSection(headerTitle: nil, cells: [subjectTypeCell, aimCell, firearmCell])]
    }
}

// MARK: - Table view data source
extension CombatSimSubjectEditViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case subjectTypeCell: navigationController?.pushViewController(subjectTypeSelectionViewController, animated: true)
        case aimCell: navigationController?.pushViewController(aimSettingSelectionViewController, animated: true)
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

        navigationController?.popViewController(animated: true)
    }
}
