//
//  CombatSimViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 10/5/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class TestSubjectAvatar: UIImageView {
    var personType: PersonType? {
        didSet {
            image = personType?.avatarImage
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(frame: .zero)

//        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        layer.cornerRadius = frame.height / 2.0
    }
}

class CombatSimResultView: BaseStackView {
    var person: Person? {
        didSet {
            avatar.personType = person?.type
            nameLabel.text = person?.type.local()
        }
    }
    var result: CombatSimulationResultSummary? {
        didSet {
            guard let result = result else { return }

            resultLabel.text = result.result.local()
            winPercentLabel.text = String(result.winPercent) + "%"
            timeToKillLabel.text = String(result.avtTtk) + "seconds_abbr".local()
            shotsToKillLabel.text = String(result.avgStk)
        }
    }
    let resultLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    let avatar: TestSubjectAvatar = TestSubjectAvatar()
    let nameLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-";
        label.textColor = .white
        return label
    }()
    let winPercentKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.text = "simulation_win_percent".local()
        label.textColor = .white
        return label
    }()
    let winPercentLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()
    let timeToKillKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.text = "simulation_time_to_kill".local()
        label.textColor = .white
        return label
    }()
    let timeToKillLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()
    let shotsToKillKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        label.text = "simulation_win_shots_to_kill".local()
        label.textColor = .white
        return label
    }()
    let shotsToKillLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    required init(coder: NSCoder) { fatalError() }

    init() {
        super.init(axis: .vertical, alignment: .center)

        addArrangedSubview(resultLabel)
        addArrangedSubview(avatar)
        addArrangedSubview(nameLabel)
        addArrangedSubview(winPercentKeyLabel)
        addArrangedSubview(winPercentLabel)
        addArrangedSubview(timeToKillKeyLabel)
        addArrangedSubview(timeToKillLabel)
        addArrangedSubview(shotsToKillKeyLabel)
        addArrangedSubview(shotsToKillLabel)

        avatar.constrainWidth(50.0)
        avatar.constrainHeight(50.0)
    }
}

class CombatSimResultsCell: BaseTableViewCell {
    var result: (CombatSimulationResultSummary, CombatSimulationResultSummary)? {
        didSet {
            subject1View.result = result?.0
            subject2View.result = result?.1
        }
    }
    let resultsStackView: BaseStackView = BaseStackView(axis: .horizontal, alignment: .top, distribution: .fillEqually)
    let subject1View: CombatSimResultView = CombatSimResultView()
    let subject2View: CombatSimResultView = CombatSimResultView()

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: nil)

        selectionStyle = .none
        isUserInteractionEnabled = false

        contentView.addSubview(resultsStackView)

        resultsStackView.pinToContainer()

        resultsStackView.addArrangedSubview(subject1View)
        resultsStackView.addArrangedSubview(subject2View)
    }
}

class CombatSimSubjectCell: BaseTableViewCell {
    var person: Person {
        didSet {
            avatar.personType = person.type
            personTypeLabel.text = person.type.local()
            aimLabel.text = person.aim.local()
            ammoLabel.text = person.firearmConfig.ammoConfiguration.compactMap{$0.resolvedAmmoName}.joined(separator: ", ")
            aimLabel.text = person.aim.local()
        }
    }
    let containerStackView: BaseStackView = BaseStackView(axis: .vertical, spacing: 15.0)

    let headerStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let avatar = TestSubjectAvatar()
    let personTypeLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let aimStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let aimKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.text = "firearm".local()
        label.textColor = .white
        return label
    }()
    let aimLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let ammoStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let ammoKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.text = "ammunition".local()
        label.textColor = .white
        return label
    }()
    let ammoLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let armorStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let armorKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.text = "armor".local()
        label.textColor = .white
        return label
    }()
    let armorLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()

    let firearmStackView: BaseStackView = BaseStackView(axis: .horizontal)
    let firearmKeyLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.text = "firearm".local()
        label.textColor = .white
        return label
    }()
    let firearmLabel: UILabel = {
        let label =  UILabel()
        label.numberOfLines = 0
        label.textAlignment = .invNatural
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.text = "-"
        label.textColor = .white
        return label
    }()


    required init?(coder: NSCoder) { fatalError() }

    init(person: Person) {
        self.person = person
        super.init(style: .default, reuseIdentifier: nil)

        contentView.addSubview(containerStackView)

        containerStackView.pinToContainer()
        containerStackView.addArrangedSubview(headerStackView)

        avatar.constrainSize(CGSize(width: 50.0, height: 50.0))
        headerStackView.addArrangedSubview(avatar)
        headerStackView.addArrangedSubview(personTypeLabel)

        containerStackView.addArrangedSubview(aimStackView)
        aimStackView.addArrangedSubview(aimKeyLabel)
        aimStackView.addArrangedSubview(aimLabel)

        containerStackView.addArrangedSubview(armorStackView)
        armorStackView.addArrangedSubview(armorKeyLabel)
        armorStackView.addArrangedSubview(armorLabel)

        containerStackView.addArrangedSubview(ammoStackView)
        ammoStackView.addArrangedSubview(ammoKeyLabel)
        ammoStackView.addArrangedSubview(ammoLabel)

        containerStackView.addArrangedSubview(firearmStackView)
        firearmStackView.addArrangedSubview(firearmKeyLabel)
        firearmStackView.addArrangedSubview(firearmLabel)
    }
}

class CombatSimViewController: StaticGroupedTableViewController {
    lazy var subject1Cell: CombatSimSubjectCell = {
        let cell = CombatSimSubjectCell(person: simulation.subject1)
        return cell
    }()
    lazy var subject2Cell: CombatSimSubjectCell = {
        let cell = CombatSimSubjectCell(person: simulation.subject2)
        return cell
    }()
    var subject1Section = GroupedTableViewSection(headerTitle: "combat_sim_subject_1".local(), cells: [])
    var subject2Section = GroupedTableViewSection(headerTitle: "combat_sim_subject_2".local(), cells: [])
    var resultSection = GroupedTableViewSection(headerTitle: "combat_sim_results".local(), cells: [])

    let resultsCell = CombatSimResultsCell()
    let simulation = CombatSimulation()

    lazy var subject1EditViewController: CombatSimSubjectEditViewController = {
        return CombatSimSubjectEditViewController(self, person: simulation.subject1)
    }()
    lazy var subject2EditViewController: CombatSimSubjectEditViewController = {
        return CombatSimSubjectEditViewController(self, person: simulation.subject2)
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init() {
        super.init()

        subject1Section.cells = [subject1Cell]
        subject2Section.cells = [subject2Cell]
        resultSection.cells = [resultsCell]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "main_menu_combat_sim".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "combat_sim_run".local(), style: .plain, target: self, action: #selector(runSim))
    }

    override func generateSections() -> [GroupedTableViewSection] {
        return [subject1Section, subject2Section]
    }

    @objc func runSim() {
        showLoading()

        simulation.runSimulation { (person1Result, person2Result) in
            self.hideLoading()

            self.resultsCell.result = (person1Result, person2Result)
            self.resultSection.cells = [self.resultsCell]
            self.sections = [self.subject1Section, self.subject2Section, self.resultSection]

            self.tableView.reloadData()
        }
    }

    override func handleCellSelected(_ cell: BaseTableViewCell) {
        switch cell {
        case subject1Cell: navigationController?.pushViewController(CombatSimSubjectEditViewController(self, person: simulation.subject1), animated: true)
        case subject2Cell: navigationController?.pushViewController(CombatSimSubjectEditViewController(self, person: simulation.subject2), animated: true)
        default: fatalError()
        }
    }
}

extension CombatSimViewController: SubjectEditViewControllerDelegate {
    func combatSimSubjectEditViewController(_ subjectEditViewController: CombatSimSubjectEditViewController, didFinishEditing subject: Person) {
        switch subjectEditViewController {
        case subject1EditViewController: simulation.subject1 = subject
        case subject2EditViewController: simulation.subject2 = subject
        default: break
        }

        navigationController?.popViewController(animated: true)
    }
}
