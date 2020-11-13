//
//  AdvancedBallisticsViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 8/8/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine
import JGProgressHUD

class AdvancedBallisticsViewController: BaseStackViewController {
    let ballisticsTest: BallisticsTest
    let dbManager = DependencyManagerImpl.shared.databaseManager()

    var ammo: SimulationAmmo? {
        didSet {
            ammoButton.item = ammo

            if let ammo = ammo {
                penetrationValueLabel.text = String(ammo.penetration)
                armorDamageValueLabel.text = String(ammo.totalArmorDamage)
                damageValueLabel.text = String(ammo.totalDamage)
                fragmentationValueLabel.text = "\(Int(ammo.fragChance * 100))%"
                damageView.enabled = true
            } else {
                penetrationValueLabel.text = "-"
                armorDamageValueLabel.text = "-"
                damageValueLabel.text = "-"
                fragmentationValueLabel.text = "-"
                headArmorPenChanceValueLabel.text = "-"
                bodyArmorPenChanceValueLabel.text = "-"
                damageView.enabled = false
            }

            updatePenetrationChances()
        }
    }
    var headArmor: SimulationArmor? {
        didSet {
            headArmorButton.item = headArmor

            if let armor = headArmor {
                headArmorGraph.valueText = "\(armor.currentDurability) / \(armor.maxDurability)"
                headArmorGraph.progress = (Float(armor.currentDurability) / Float(armor.maxDurability))

                let simArmor = BEArmor.create(armor: armor)
                ballisticsTest.person.equipArmor(simArmor)
            } else {
                headArmorGraph.valueText = "- / -"
                headArmorGraph.progress = 0.0
            }

            updatePenetrationChances()
        }
    }
    var bodyArmor: SimulationArmor? {
        didSet {
            bodyArmorButton.item = bodyArmor

            if let armor = bodyArmor {
                bodyArmorGraph.progress = (Float(armor.currentDurability) / Float(armor.maxDurability))
                bodyArmorGraph.valueText = "\(armor.currentDurability) / \(armor.maxDurability)"

                let simArmor = BEArmor.create(armor: armor)
                ballisticsTest.person.equipArmor(simArmor)
            } else {
                bodyArmorGraph.valueText = "- / -"
                bodyArmorGraph.progress = 0.0
            }

            updatePenetrationChances()
        }
    }
    var ammoOptions: [Ammo]?
    var headArmorOptions: [Armor]?
    var bodyArmorOptions: [Armor]?

    let selectionCellId = "ItemSelectionCell"
    let characterOptions: [Character]
    var currentCharacterSelection: Character {
        didSet {
            reset()
            bodyArmor = bodyArmor?.copy() as? SimulationArmor
            headArmor = headArmor?.copy() as? SimulationArmor
            configureDamageView()
        }
    }
    lazy var subjectTypeSelectionViewController: SelectionViewController = {
        return SelectionViewController(self, title: "combat_sim_subject_type".local(), options: characterOptions)
    }()
    lazy var damageView: TargetDamageView = {
        let damageView = TargetDamageView(currentCharacterSelection)
        return damageView
    }()

    let penetrationKeyLabel = createKeyLabel("sim_pen".local())
    let damageKeyLabel = createKeyLabel("sim_damage".local())
    let armorDamageKeyLabel = createKeyLabel("sim_armor_damage".local())
    let fragmentationKeyLabel = createKeyLabel("sim_frag".local())
    let headArmorPenChanceKeyLabel = createKeyLabel("sim_pen_chance".local())
    let bodyArmorPenChanceKeyLabel = createKeyLabel("sim_pen_chance".local())

    let penetrationValueLabel = createValueLabel("-")
    let damageValueLabel = createValueLabel("-")
    let armorDamageValueLabel = createValueLabel("-")
    let fragmentationValueLabel = createValueLabel("-")
    let headArmorPenChanceValueLabel = createValueLabel("-")
    let bodyArmorPenChanceValueLabel = createValueLabel("-")

    static func createKeyLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }

    static func createValueLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .invNatural
        return label
    }

    let penChanceSettingSwitch: UISegmentedControl = {
        let items = ["chance_setting_realistic".local(), "chance_setting_always".local(), "chance_setting_never".local()]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.Theme.primary
        }
        segmentedControl.backgroundColor = .lightGray
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        return segmentedControl
    }()
    let penChanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "pen_chance".local()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    let fragChanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "frag_chance".local()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
    let fragChanceSettingSwitch: UISegmentedControl = {
        let items = ["chance_setting_realistic".local(), "chance_setting_always".local(), "chance_setting_never".local()]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.Theme.primary
        }
        segmentedControl.backgroundColor = .lightGray
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        return segmentedControl
    }()
    lazy var ammoButton: ItemPreviewButton = {
        let button = ItemPreviewButton()
        button.placeholderText = "choose_ammo".local()
        button.addTarget(self, action: #selector(showAmmoOptions), for: .touchUpInside)
        return button
    }()
    lazy var headArmorButton: ItemPreviewButton = {
        let button = ItemPreviewButton()
        button.placeholderText = "choose_head_armor".local()
        button.addTarget(self, action: #selector(showHeadArmorOptions), for: .touchUpInside)
        return button
    }()
    lazy var bodyArmorButton: ItemPreviewButton = {
        let button = ItemPreviewButton()
        button.placeholderText = "choose_body_armor".local()
        button.addTarget(self, action: #selector(showBodyArmorOptions), for: .touchUpInside)
        return button
    }()

    let itemStackView = BaseStackView(axis: .horizontal, distribution: .fillEqually, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)

    let ammoStackView = BaseStackView(axis: .vertical, distribution: .equalSpacing, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let headArmorStackView = BaseStackView(axis: .vertical, distribution: .equalSpacing, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let bodyArmorStackView = BaseStackView(axis: .vertical, distribution: .equalSpacing, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)

    let damageStackView = BaseStackView(axis: .horizontal, distribution: .fillProportionally, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let fragStackView = BaseStackView(axis: .horizontal, distribution: .fillProportionally, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let armorDamageStackView = BaseStackView(axis: .horizontal, distribution: .fillProportionally, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let penStackView = BaseStackView(axis: .horizontal, distribution: .fillProportionally, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)

    let headArmorPenChanceStackView = BaseStackView(axis: .horizontal, distribution: .fillProportionally, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let bodyArmorPenChanceStackView = BaseStackView(axis: .horizontal, distribution: .fillProportionally, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)

    let headArmorGraph = BarGraphView()
    let bodyArmorGraph = BarGraphView()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(characterOptions: [Character]) {
        self.characterOptions = characterOptions

        guard let defaultChar = characterOptions.first else { fatalError() }
        currentCharacterSelection = defaultChar
        ballisticsTest = BallisticsTest(initialHealthMap: defaultChar.convertedHealthMap())

        super.init(BaseStackView(axis: .vertical, spacing: 15.0))

        configureDamageView()
        updatePenetrationChances()
        reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "advanced_ballistics_test".local()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "common_reset".local(), style: .plain, target: self, action: #selector(reset))

        stackView.addArrangedSubview(damageView)

        stackView.addArrangedSubview(headArmorButton)
        stackView.addArrangedSubview(itemStackView)

        stackView.addArrangedSubview(penChanceTitleLabel)
        stackView.addArrangedSubview(penChanceSettingSwitch)
        stackView.addArrangedSubview(fragChanceTitleLabel)
        stackView.addArrangedSubview(fragChanceSettingSwitch)

        itemStackView.addArrangedSubview(ammoStackView)
        itemStackView.addArrangedSubview(headArmorStackView)
        itemStackView.addArrangedSubview(bodyArmorStackView)

        headArmorStackView.addArrangedSubview(headArmorButton)
        headArmorStackView.addArrangedSubview(headArmorGraph)
        headArmorStackView.addArrangedSubview(headArmorPenChanceStackView)
        headArmorStackView.addArrangedSubview(UIView())
        headArmorStackView.addArrangedSubview(UIView())

        bodyArmorStackView.addArrangedSubview(bodyArmorButton)
        bodyArmorStackView.addArrangedSubview(bodyArmorGraph)
        bodyArmorStackView.addArrangedSubview(bodyArmorPenChanceStackView)
        bodyArmorStackView.addArrangedSubview(UIView())
        bodyArmorStackView.addArrangedSubview(UIView())

        ammoStackView.addArrangedSubview(ammoButton)
        ammoStackView.addArrangedSubview(damageStackView)
        ammoStackView.addArrangedSubview(penStackView)
        ammoStackView.addArrangedSubview(armorDamageStackView)
        ammoStackView.addArrangedSubview(fragStackView)

        headArmorPenChanceStackView.addArrangedSubview(headArmorPenChanceKeyLabel)
        headArmorPenChanceStackView.addArrangedSubview(headArmorPenChanceValueLabel)

        bodyArmorPenChanceStackView.addArrangedSubview(bodyArmorPenChanceKeyLabel)
        bodyArmorPenChanceStackView.addArrangedSubview(bodyArmorPenChanceValueLabel)

        damageStackView.addArrangedSubview(damageKeyLabel)
        damageStackView.addArrangedSubview(damageValueLabel)
        penStackView.addArrangedSubview(penetrationKeyLabel)
        penStackView.addArrangedSubview(penetrationValueLabel)
        armorDamageStackView.addArrangedSubview(armorDamageKeyLabel)
        armorDamageStackView.addArrangedSubview(armorDamageValueLabel)
        fragStackView.addArrangedSubview(fragmentationKeyLabel)
        fragStackView.addArrangedSubview(fragmentationValueLabel)

        ammoButton.constrainHeight(110.0)
        headArmorButton.constrainHeight(110.0)
        bodyArmorButton.constrainHeight(110.0)
        damageView.constrainHeight(view.frame.height * 0.5)
        penChanceSettingSwitch.constrainHeight(40.0)
        fragChanceSettingSwitch.constrainHeight(40.0)

        headArmorGraph.widthMultiplier = 1.0
        headArmorGraph.constrainHeight(30.0)
        bodyArmorGraph.widthMultiplier = 1.0
        bodyArmorGraph.constrainHeight(30.0)
    }

    private func updateGraphs() {
        if let _ = bodyArmor {
            if let armor = ballisticsTest.person.armor.first(where: { (a) -> Bool in return a.protectedZoneTypes.contains(.thorax) }) {
                bodyArmorGraph.progress = (Float(armor.currentDurability) / Float(armor.originalMaxDurability))
                bodyArmorGraph.valueText = String(format: "%.1f / %.1f", armor.currentDurability, armor.originalMaxDurability)
            }
        }

        if let _ = headArmor {
            if let armor = ballisticsTest.person.armor.first(where: { (a) -> Bool in return !a.protectedZoneTypes.contains(.thorax) }) {
                headArmorGraph.progress = (Float(armor.currentDurability) / Float(armor.originalMaxDurability))
                headArmorGraph.valueText = String(format: "%.1f / %.1f", armor.currentDurability, armor.originalMaxDurability)
            }
        }
    }

    private func configureDamageView() {
        damageView.characterType = currentCharacterSelection

        damageView.avatar.addTarget(self, action: #selector(showCharacterOptions), for: .touchUpInside)
        damageView.headButton.addTarget(self, action: #selector(processHeadShot), for: .touchUpInside)
        damageView.thoraxButton.addTarget(self, action: #selector(processChestShot), for: .touchUpInside)
        damageView.rightArmButton.addTarget(self, action: #selector(processRArmShot), for: .touchUpInside)
        damageView.leftArmButton.addTarget(self, action: #selector(processLArmShot), for: .touchUpInside)
        damageView.stomachButton.addTarget(self, action: #selector(processStomachShot), for: .touchUpInside)
        damageView.leftLegButton.addTarget(self, action: #selector(processLLegShot), for: .touchUpInside)
        damageView.rightLegButton.addTarget(self, action: #selector(processRLegShot), for: .touchUpInside)
    }

    private func reloadData() {
        damageView.target = ballisticsTest.person
        updatePenetrationChances()
        updateGraphs()
        updateSummary()
    }

    private func updateSummary() {
        guard let history = ballisticsTest.history.last else { return }
        let before = history.beforeSnapshot
        let after = history.afterSnapshot

        let fleshDamage = before.personSnapshot.totalHp - after.personSnapshot.totalHp
        let armorDamage = before.personSnapshot.armor.reduce(0){ $0 + $1.currentDurability } - after.personSnapshot.armor.reduce(0){ $0 + $1.currentDurability }
        let wasFatal = before.personSnapshot.isAlive && !after.personSnapshot.isAlive
        let penetrated = after.ammoSnapshot.hasPenetrated
        print("flesh: \(fleshDamage), armor: \(armorDamage), penetrated: \(penetrated), fatal: \(wasFatal)")
    }

    private func updatePenetrationChances() {
        if let ammo = ammo {
            let testAmmo = BEAmmo(damage: ammo.resolvedDamage, penetration: ammo.resolvedPenetration, fragmentation: ammo.resolvedFragmentationChance, armorDamage: ammo.resolvedArmorDamage, hasFragmented: ammo.fragmented)

            if let headArmor = ballisticsTest.person.armor.first(where: { !$0.protectedZoneTypes.contains(.thorax) }) {
                let chance = headArmor.penetrationChanceOfAmmo(testAmmo)
                headArmorPenChanceValueLabel.text = String(format: "%.1f", chance) + "%"
            } else {
                headArmorPenChanceValueLabel.text = "100%"
            }

            if let bodyArmor = ballisticsTest.person.armor.first(where: { $0.protectedZoneTypes.contains(.thorax) }) {
                let chance = bodyArmor.penetrationChanceOfAmmo(testAmmo)
                bodyArmorPenChanceValueLabel.text = String(format: "%.1f", chance) + "%"
            } else {
                bodyArmorPenChanceValueLabel.text = "100%"
            }
        } else {
            headArmorPenChanceValueLabel.text = "-"
        }
    }

    @objc func showCharacterOptions() {
        subjectTypeSelectionViewController.currentSelection = currentCharacterSelection
        navigationController?.pushViewController(subjectTypeSelectionViewController, animated: true)
    }

    @objc func processHeadShot() {
        processShotToZone(ballisticsTest.person.head)
    }

    @objc func processChestShot() {
        processShotToZone(ballisticsTest.person.thorax)
    }

    @objc func processRArmShot() {
        processShotToZone(ballisticsTest.person.armR)
    }

    @objc func processLArmShot() {
        processShotToZone(ballisticsTest.person.armL)
    }

    @objc func processStomachShot() {
        processShotToZone(ballisticsTest.person.stomach)
    }

    @objc func processLLegShot() {
        processShotToZone(ballisticsTest.person.legL)
    }

    @objc func processRLegShot() {
        processShotToZone(ballisticsTest.person.legR)
    }

    private func getCurrenPenChanceSetting() -> ChanceSetting {
        switch penChanceSettingSwitch.selectedSegmentIndex {
        case 0: return .realistic
        case 1: return .always
        case 2: return .never
        default: fatalError()
        }
    }

    private func getCurrenFragChanceSetting() -> ChanceSetting {
        switch fragChanceSettingSwitch.selectedSegmentIndex {
        case 0: return .realistic
        case 1: return .always
        case 2: return .never
        default: fatalError()
        }
    }

    private func processShotToZone(_ zone: BEZone) {
        guard ballisticsTest.person.isAlive, let ammo = ammo else { return }
        let testAmmo = BEAmmo(damage: ammo.resolvedDamage, penetration: ammo.resolvedPenetration, fragmentation: ammo.resolvedFragmentationChance, armorDamage: ammo.resolvedArmorDamage, hasFragmented: ammo.fragmented)
        ballisticsTest.processImpact(zone: zone, with: testAmmo, penSetting: getCurrenPenChanceSetting(), fragSetting: getCurrenFragChanceSetting())
        reloadData()
    }

    @objc func showAmmoOptions() {
        if let options = ammoOptions {
            let selectAmmoVC = SortableTableViewController(selectionDelegate: self, config: AmmoSortConfig(options: options), currentSelection: ammo)
            let nc = BaseNavigationController(rootViewController: selectAmmoVC)
            present(nc, animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.position = .center
            hud.show(in: self.scrollView)

            dbManager.getAllAmmo(handler: { allAmmo in
                hud.dismiss(animated: false)
                self.ammoOptions = allAmmo.compactMap { SimulationAmmo(json:$0.json) }
                self.showAmmoOptions()
            })
        }
    }

    @objc func showHeadArmorOptions() {
        if let options = headArmorOptions {
            let selectArmorVC = SortableTableViewController(selectionDelegate: self, config: ArmorSortConfig(options: options), currentSelection: headArmor)
            let nc = BaseNavigationController(rootViewController: selectArmorVC)
            present(nc, animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.position = .center
            hud.show(in: self.scrollView)

            dbManager.getAllHeadArmor(handler: { allHeadArmor in
                hud.dismiss(animated: false)
                self.headArmorOptions = allHeadArmor.compactMap { SimulationArmor(json:$0.json) }
                self.showHeadArmorOptions()
            })
        }
    }

    @objc func showBodyArmorOptions() {
        if let options = bodyArmorOptions {
            let selectArmorVC = SortableTableViewController(selectionDelegate: self, config: ArmorSortConfig(options: options), currentSelection: bodyArmor)
            let nc = BaseNavigationController(rootViewController: selectArmorVC)
            present(nc, animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.position = .center
            hud.show(in: self.scrollView)

            dbManager.getAllBodyArmor { allBodyArmor in
                hud.dismiss(animated: false)
                self.bodyArmorOptions = allBodyArmor.compactMap { SimulationArmor(json:$0.json) }
                self.showBodyArmorOptions()
            }
        }
    }

    @objc func reset() {
        ballisticsTest.reset()
        reloadData()
    }
}

extension AdvancedBallisticsViewController: SortableItemSelectionDelegate {
    func itemSelected(_ selection: Sortable) {
        switch selection {
        case let selectedAmmo as SimulationAmmo:
            ammo = selectedAmmo
        case let selectedArmor as SimulationArmor:
            if selectedArmor.armorType == .body {
                bodyArmor = selectedArmor
            } else {
                headArmor = selectedArmor
            }
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }

    func itemCleared(clearedSelection: Sortable) {
        switch clearedSelection {
        case _ as SimulationAmmo:
            ammo = nil
        case let selectedArmor as SimulationArmor:
            if selectedArmor.armorType == .body {
                bodyArmor = nil
            } else {
                headArmor = nil
            }
        default:
            break
        }
        dismiss(animated: true, completion: nil)
    }

    func selectionCancelled() {
        dismiss(animated: true, completion: nil)
    }
}

extension AdvancedBallisticsViewController: SelectionDelegate {
    func selectionViewController(_ selectionViewController: SelectionViewController, didMakeSelection selection: SelectionOption) {
        guard let selection = selection as? Character, let newCharacter = SimulationCharacter(json: selection.json) else { return }

        currentCharacterSelection = newCharacter
        ballisticsTest.healthMap = selection.convertedHealthMap()

        navigationController?.popViewController(animated: true)
    }
}
