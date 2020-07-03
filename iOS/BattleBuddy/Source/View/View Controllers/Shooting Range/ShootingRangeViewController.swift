//
//  ShootingRangeViewController.swift
//  BattleBuddy
//
//  Created by Veritas on 6/24/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class ShootingRangeArmorCell: BaseTableViewCell {
    let firebaseManager = DependencyManagerImpl.shared.firebaseManager()
    let contentStackView: BaseStackView = BaseStackView(axis: .horizontal, alignment: .top, distribution: .fillEqually)
    let placeholderImage: UIImage?
    let armorImageView = BaseImageView(imageSize: .medium, aspectRatio: .standard)
    var armor: Armor? {
        didSet {
            guard let armor = self.armor else {
                imageView?.image = placeholderImage
                return
            }

            armorImageView.displayableItem = armor
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    init(type: ArmorType) {
        switch type {
        case .body: placeholderImage = UIImage(named: "class_5_placeholder")?.withRenderingMode(.alwaysTemplate)
        default: placeholderImage = UIImage(named: "class_4_placeholder_helmet")?.withRenderingMode(.alwaysTemplate)
        }

        super.init(style: .default, reuseIdentifier: nil)

        armorImageView.image = placeholderImage

        contentView.addSubview(contentStackView)

        contentStackView.pinToContainer()

        contentStackView.addArrangedSubview(armorImageView)
    }
}

class ShootingRangeViewController: StaticGroupedTableViewController {
    var target: Character
    var ammo: SimulationAmmo?
    let combatCalc = CombatCalculator()
    var penSetting: ChanceSetting = .realistic
    var fragSetting: ChanceSetting = .realistic
    public var helmet: Armor? { didSet { helmetCell.armor = helmet } }
    public var bodyArmor: Armor? { didSet { bodyArmorCell.armor = bodyArmor } }

    let helmetCell = ShootingRangeArmorCell(type: .helmet)
    let bodyArmorCell = ShootingRangeArmorCell(type: .body)
    lazy var targetSection = GroupedTableViewSection(headerTitle: "shooting_range_target_settings".local(), cells: [helmetCell, bodyArmorCell])

    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(defaultCharacter: Character) {
        self.target = defaultCharacter
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "main_menu_shooting_range".local()
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh, target: self, action: #selector(reset))
    }

    override func generateSections() -> [GroupedTableViewSection] { return [targetSection] }

    @objc func reset() {

    }

    func handleImact() {
        guard let ammo = self.ammo else { fatalError() }
        guard let character = SimulationCharacter(json: target.json) else { return }
        let person = Person(character)
        let result = combatCalc.processImpact(to: person, zoneType: .head, with: ammo, penSetting: penSetting, fragSetting: fragSetting)
    }
}

// Health map slider handling
extension ShootingRangeViewController {

}
