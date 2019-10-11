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

class CombatSimSubjectEditViewController: BaseTableViewController {
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
    var sections: [GroupedTableViewSection] = []
    lazy var subjectTypeSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, options: [])
    }()
    lazy var aimSettingSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, options: [AimSetting.centerOfMass, AimSetting.headshotsOnly, AimSetting.thoraxOnly, AimSetting.randomLegMeta, AimSetting.singleLegMeta])
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(_ subjectEditDelegate: SubjectEditViewControllerDelegate, person: Person) {
        self.subjectEditDelegate = subjectEditDelegate
        self.person = person
        super.init(style: .grouped)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "combat_sim_edit_subject".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(save))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateCells()
    }

    func updateCells() {
        sections = []
        sections.append(GroupedTableViewSection(headerTitle: nil, cells: []))
        tableView.reloadData()
    }

    @objc func save() {
        // TODO: Gather data from UI and package into Person
        let person = Person(.dealmaker, aimSetting: .centerOfMass, armor: [], firearm: nil)
        subjectEditDelegate.combatSimSubjectEditViewController(self, didFinishEditing: person)
    }
}

// MARK: - Table view data source
extension CombatSimSubjectEditViewController {
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

        let cell = tableView.cellForRow(at: indexPath)
        switch cell {
        case aimCell: navigationController?.pushViewController(SelectionViewController(self, options: []), animated: true)
        default: break
        }
    }
}

extension CombatSimSubjectEditViewController: SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption) {
        switch selectionViewController {
        case aimSettingSelectionViewController:
            guard let aimSetting = selection as? AimSetting else { fatalError() }
            person.aim = aimSetting
        default:
            break
        }
    }
}
