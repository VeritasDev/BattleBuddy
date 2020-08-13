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
    let combatCalc = CombatCalculator()
    let dbManager = DependencyManagerImpl.shared.databaseManager()
    var result: BallisticsResult? {
        didSet {
            guard let result = result else { return }

            self.target = result.target

            if let armor = result.target.config.resolvedBodyArmor as? SimulationArmor {
                bodyArmor = armor
                var info: [String] = []
                let damage = armor.resolvedPriorDamage
                if damage > 0 {
                    info.append("-\(Int(damage))")
                }
                bodyArmorButton.setInfo(info)
            } else {
                bodyArmorButton.setInfo([])
            }

            if let armor = result.target.config.resolvedHeadArmor as? SimulationArmor {
                self.headArmor = armor
                var info: [String] = []
                let damage = armor.resolvedPriorDamage
                if damage > 0 {
                    info.append("-\(Int(damage))")
                }
                headArmorButton.setInfo(info)
            } else {
                headArmorButton.setInfo([])
            }

            let didPen = result.metadata.didPenetrateToFlesh ? "Penetrated" : "Stopped"
            if result.metadata.fragmentationOccurred {
                ammoButton.setInfo([didPen, "Fragmented"])
            } else {
                ammoButton.setInfo([didPen])
            }
        }
    }
    var target: Person? {
        didSet {
            damageView.target = target
        }
    }
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
                damageView.enabled = false
            }
        }
    }
    var headArmor: SimulationArmor? {
        didSet {
            headArmorButton.item = headArmor
            target?.config.resolvedHeadArmor = headArmor

            if let armor = headArmor {
                headArmorGraph.valueText = "\(armor.currentDurability) / \(armor.maxDurability)"
                headArmorGraph.progress = (Float(armor.currentDurability) / Float(armor.maxDurability))
                headArmorCustomDurabilityButton.enable(true)
            } else {
                headArmorGraph.valueText = "- / -"
                headArmorGraph.progress = 0.0
                headArmorCustomDurabilityButton.enable(false)
            }
        }
    }
    var bodyArmor: SimulationArmor? {
        didSet {
            bodyArmorButton.item = bodyArmor
            target?.config.resolvedBodyArmor = bodyArmor

            if let armor = bodyArmor {
                bodyArmorGraph.progress = (Float(armor.currentDurability) / Float(armor.maxDurability))
                bodyArmorGraph.valueText = "\(armor.currentDurability) / \(armor.maxDurability)"
                bodyArmorCustomDurabilityButton.enable(true)
            } else {
                bodyArmorGraph.valueText = "- / -"
                bodyArmorGraph.progress = 0.0
                bodyArmorCustomDurabilityButton.enable(false)
            }
        }
    }
    var ammoOptions: [Ammo]?
    var headArmorOptions: [Armor]?
    var bodyArmorOptions: [Armor]?

    let selectionCellId = "ItemSelectionCell"
    let characterOptions: [Character]
    let damageView = TargetDamageView()
    let ammoConfigHeader: UILabel = {
        let label = UILabel()
        label.text = "ammo_config".local()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    let armorConfigHeader: UILabel = {
        let label = UILabel()
        label.text = "armor_config".local()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    let healthStatusHeader: UILabel = {
        let label = UILabel()
        label.text = "health_status".local()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    let simDataHeader: UILabel = {
        let label = UILabel()
        label.text = "simulation_data".local()
        label.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        label.textColor = .white
        return label
    }()

    let ammoStackView = BaseStackView(axis: .horizontal, distribution: .fillEqually, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let damageStackView = BaseStackView(axis: .horizontal, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let fragStackView = BaseStackView(axis: .horizontal, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let armorDamageStackView = BaseStackView(axis: .horizontal, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let penStackView = BaseStackView(axis: .horizontal, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let ammoPropertiesStackView = BaseStackView(axis: .vertical, distribution: .equalSpacing)

    let penetrationKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "sim_pen".local()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }()
    let penetrationValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .invNatural
        return label
    }()
    let damageKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "sim_damage".local()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }()
    let damageValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .invNatural
        return label
    }()
    let armorDamageKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "sim_armor_damage".local()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }()
    let armorDamageValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .invNatural
        return label
    }()
    let fragmentationKeyLabel: UILabel = {
        let label = UILabel()
        label.text = "sim_frag".local()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = .white
        return label
    }()
    let fragmentationValueLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .bold)
        label.textColor = UIColor.Theme.primary
        label.textAlignment = .invNatural
        return label
    }()
    let penChanceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "pen_chance".local()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textColor = .white
        return label
    }()
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

    let divider1 = createDividerLine()
    let divider2 = createDividerLine()
    let divider3 = createDividerLine()
    let divider4 = createDividerLine()

    let spacer1 = UIView()
    let spacer2 = UIView()

    let armorStackView = BaseStackView(axis: .horizontal, distribution: .fillEqually, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let headArmorStackView = BaseStackView(axis: .vertical, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)
    let bodyArmorStackView = BaseStackView(axis: .vertical, xPaddingCompact: 0.0, xPaddingRegular: 0.0, yPadding: 0.0)

    let headArmorGraph = BarGraphView()
    let bodyArmorGraph = BarGraphView()

    let headArmorCustomDurabilityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("common_customize".local(), for: .normal)
        button.setTitleColor(UIColor.Theme.primary, for: .normal)
        button.tintColor = UIColor.Theme.primary
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        button.addTarget(self, action: #selector(customizeHeadArmor), for: .touchUpInside)
        button.alpha = 0.2
        return button
    }()
    let bodyArmorCustomDurabilityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("common_customize".local(), for: .normal)
        button.setTitleColor(UIColor.Theme.primary, for: .normal)
        button.tintColor = UIColor.Theme.primary
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        button.isEnabled = false
        button.addTarget(self, action: #selector(customizeBodyArmor), for: .touchUpInside)
        button.alpha = 0.2
        return button
    }()

    static func createDividerLine() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(characterOptions: [Character]) {
        self.characterOptions = characterOptions

        guard let defaultChar = characterOptions.first, let simChar = SimulationCharacter(json: defaultChar.json) else { fatalError() }
        target = Person(simChar)

        super.init(BaseStackView(axis: .vertical, spacing: 15.0))

        configureDamageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "advanced_ballistics_test".local()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "common_reset".local(), style: .plain, target: self, action: #selector(reset))

        stackView.addArrangedSubview(healthStatusHeader)
        stackView.addArrangedSubview(divider1)
        stackView.addArrangedSubview(damageView)

        stackView.addArrangedSubview(armorConfigHeader)
        stackView.addArrangedSubview(divider3)
        stackView.addArrangedSubview(headArmorButton)
        stackView.addArrangedSubview(armorStackView)

        stackView.addArrangedSubview(spacer2)
        stackView.addArrangedSubview(ammoConfigHeader)
        stackView.addArrangedSubview(divider2)
        stackView.addArrangedSubview(ammoStackView)
        stackView.addArrangedSubview(penChanceTitleLabel)
        stackView.addArrangedSubview(penChanceSettingSwitch)
        stackView.addArrangedSubview(fragChanceTitleLabel)
        stackView.addArrangedSubview(fragChanceSettingSwitch)

        ammoStackView.addArrangedSubview(ammoButton)
        ammoStackView.addArrangedSubview(ammoPropertiesStackView)

        ammoPropertiesStackView.addArrangedSubview(damageStackView)
        ammoPropertiesStackView.addArrangedSubview(penStackView)
        ammoPropertiesStackView.addArrangedSubview(armorDamageStackView)
        ammoPropertiesStackView.addArrangedSubview(fragStackView)

        damageStackView.addArrangedSubview(damageKeyLabel)
        damageStackView.addArrangedSubview(damageValueLabel)
        penStackView.addArrangedSubview(penetrationKeyLabel)
        penStackView.addArrangedSubview(penetrationValueLabel)
        armorDamageStackView.addArrangedSubview(armorDamageKeyLabel)
        armorDamageStackView.addArrangedSubview(armorDamageValueLabel)
        fragStackView.addArrangedSubview(fragmentationKeyLabel)
        fragStackView.addArrangedSubview(fragmentationValueLabel)

        armorStackView.addArrangedSubview(headArmorStackView)
        armorStackView.addArrangedSubview(bodyArmorStackView)

        headArmorStackView.addArrangedSubview(headArmorButton)
        headArmorStackView.addArrangedSubview(headArmorGraph)
//        headArmorStackView.addArrangedSubview(headArmorCustomDurabilityButton)

        bodyArmorStackView.addArrangedSubview(bodyArmorButton)
        bodyArmorStackView.addArrangedSubview(bodyArmorGraph)
//        bodyArmorStackView.addArrangedSubview(bodyArmorCustomDurabilityButton)

        ammoButton.constrainHeight(130.0)
        headArmorButton.constrainHeight(130.0)
        bodyArmorButton.constrainHeight(130.0)
        damageView.constrainHeight(view.frame.height * 0.5)
        penChanceSettingSwitch.constrainHeight(40.0)
        fragChanceSettingSwitch.constrainHeight(40.0)
        divider1.constrainHeight(1.0)
        divider2.constrainHeight(1.0)
        divider3.constrainHeight(1.0)
        divider4.constrainHeight(1.0)
        spacer1.constrainHeight(4.0)
        spacer2.constrainHeight(4.0)

        headArmorGraph.widthMultiplier = 1.0
        headArmorGraph.constrainHeight(30.0)
        bodyArmorGraph.widthMultiplier = 1.0
        bodyArmorGraph.constrainHeight(30.0)
    }

    private func configureDamageView() {
        guard let target = target else { fatalError() }
        damageView.target = target

        damageView.headButton.addTarget(self, action: #selector(processHeadShot), for: .touchUpInside)
        damageView.thoraxButton.addTarget(self, action: #selector(processChestShot), for: .touchUpInside)
        damageView.rightArmButton.addTarget(self, action: #selector(processRArmShot), for: .touchUpInside)
        damageView.leftArmButton.addTarget(self, action: #selector(processLArmShot), for: .touchUpInside)
        damageView.stomachButton.addTarget(self, action: #selector(processStomachShot), for: .touchUpInside)
        damageView.leftLegButton.addTarget(self, action: #selector(processLLegShot), for: .touchUpInside)
        damageView.rightLegButton.addTarget(self, action: #selector(processRLegShot), for: .touchUpInside)
    }

    @objc func processHeadShot() {
        processShotToZone(.head)
    }

    @objc func processChestShot() {
        processShotToZone(.thorax)
    }

    @objc func processRArmShot() {
        processShotToZone(.rightArm)
    }

    @objc func processLArmShot() {
        processShotToZone(.leftArm)
    }

    @objc func processStomachShot() {
        processShotToZone(.stomach)
    }

    @objc func processLLegShot() {
        processShotToZone(.leftLeg)
    }

    @objc func processRLegShot() {
        processShotToZone(.rightLeg)
    }

    private func processShotToZone(_ zone: BodyZoneType) {
        guard let ammo = ammo, let person = target else { fatalError() }

        let pen: ChanceSetting
        let frag: ChanceSetting

        switch penChanceSettingSwitch.selectedSegmentIndex {
        case 0: pen = .realistic
        case 1: pen = .always
        case 2: pen = .never
        default: fatalError()
        }

        switch fragChanceSettingSwitch.selectedSegmentIndex {
        case 0: frag = .realistic
        case 1: frag = .always
        case 2: frag = .never
        default: fatalError()
        }

        self.result = combatCalc.processImpact(to: person, zoneType: zone, with: ammo, penSetting: pen, fragSetting: frag)
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

    @objc func customizeHeadArmor() {
        guard let armor = headArmor else { return }
    }

    @objc func customizeBodyArmor() {
        guard let armor = bodyArmor else { return }
    }

    @objc func reset() {
//        target = Person(character)
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
