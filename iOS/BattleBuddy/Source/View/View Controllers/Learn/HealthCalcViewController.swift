//
//  HealthCalcViewController.swift
//  BattleBuddy
//
//  Created by Mike on 7/20/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine
import JGProgressHUD

class HealthCalcViewController: BaseViewController, SortableItemSelectionDelegate, HealthCalculatorDelegate {
    lazy var calculator: HealthCalculator = {
        let calc = HealthCalculator()
        calc.delegate = self
        calc.fragChanceSetting = .never
        return calc
    }()
    var target: Person? {
        didSet {
            guard let newTarget = target else { return }
            headButton.zone = newTarget.head
            thoraxButton.zone = newTarget.thorax
            stomachButton.zone = newTarget.stomach
            rightArmButton.zone = newTarget.rightArm
            leftArmButton.zone = newTarget.leftArm
            rightLegButton.zone = newTarget.rightLeg
            leftLegButton.zone = newTarget.leftLeg
            currentHealthLabel.text = String(Int(newTarget.totalCurrentHp))
            maxHealthLabel.text = "/ \(Int(newTarget.totalOriginalHp))"
        }
    }
    let selectionCellId = "ItemSelectionCell"
    let skeletonBackgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "health_calc_skeleton")!)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.1
        return imageView
    }()
    let hpIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "health_star")!)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var currentHealthLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 40, weight: .semibold)
        label.textColor = UIColor(red: 0.56, green: 0.79, blue: 0.19, alpha: 1.0)
        return label
    }()
    lazy var maxHealthLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor.init(white: 0.7, alpha: 1.0)
        return label
    }()
    let headButton = BodyZoneHealthButton()
    let thoraxButton = BodyZoneHealthButton()
    let stomachButton = BodyZoneHealthButton()
    let rightArmButton = BodyZoneHealthButton()
    let leftArmButton = BodyZoneHealthButton()
    let rightLegButton = BodyZoneHealthButton()
    let leftLegButton = BodyZoneHealthButton()
    let reloadButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "reload")?.imageScaled(toFit: CGSize(width: 35.0, height: 35.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor.Theme.primary
        return button
    }()
    let settingsButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle("select_ammo".local(), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11.0, weight: .bold)
        button.titleLabel?.numberOfLines = 0
        button.tintColor = UIColor.Theme.primary
        button.backgroundColor = UIColor.Theme.primary
        button.layer.cornerRadius = 7.0
        return button
    }()

    var ammo: Ammo? {
        didSet {
            settingsButton.setTitle(ammo?.displayName, for: .normal)
        }
    }
    var ammoOptions: [Ammo]?

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init() {
        self.target = Person(.pmc)
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Localized("main_menu_health_calc")

        edgesForExtendedLayout = []
        view.backgroundColor = UIColor(white: 0.07, alpha: 1.0)
        view.backgroundColor = UIColor(white: 0.07, alpha: 1.0)

        view.addSubview(skeletonBackgroundImage)
        view.addSubview(headButton)
        view.addSubview(thoraxButton)
        view.addSubview(stomachButton)
        view.addSubview(rightArmButton)
        view.addSubview(leftArmButton)
        view.addSubview(leftLegButton)
        view.addSubview(rightLegButton)
        view.addSubview(hpIconImageView)
        view.addSubview(currentHealthLabel)
        view.addSubview(maxHealthLabel)
        view.addSubview(reloadButton)
        view.addSubview(settingsButton)

        headButton.addTarget(self, action: #selector(handleHeadshot), for: .touchUpInside)
        thoraxButton.addTarget(self, action: #selector(handleThoraxShot), for: .touchUpInside)
        stomachButton.addTarget(self, action: #selector(handleStomachShot), for: .touchUpInside)
        leftArmButton.addTarget(self, action: #selector(handleLeftArmShot), for: .touchUpInside)
        rightArmButton.addTarget(self, action: #selector(handleRightArmShot), for: .touchUpInside)
        leftLegButton.addTarget(self, action: #selector(handleLeftLegShot), for: .touchUpInside)
        rightLegButton.addTarget(self, action: #selector(handleRightLegShot), for: .touchUpInside)
        settingsButton.addTarget(self, action: #selector(showSettings), for: .touchUpInside)
        reloadButton.addTarget(self, action: #selector(reset), for: .touchUpInside)

        currentHealthLabel.translatesAutoresizingMaskIntoConstraints = false
        maxHealthLabel.translatesAutoresizingMaskIntoConstraints = false
        hpIconImageView.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            currentHealthLabel.topAnchor.constraint(equalTo: leftLegButton.bottomAnchor, constant: 20.0),
            currentHealthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hpIconImageView.trailingAnchor.constraint(equalTo: currentHealthLabel.leadingAnchor, constant: -10.0),
            hpIconImageView.heightAnchor.constraint(equalTo: currentHealthLabel.heightAnchor, multiplier: 0.7),
            hpIconImageView.widthAnchor.constraint(equalTo: hpIconImageView.heightAnchor),
            hpIconImageView.centerYAnchor.constraint(equalTo: currentHealthLabel.centerYAnchor),
            maxHealthLabel.leadingAnchor.constraint(equalTo: currentHealthLabel.trailingAnchor, constant: 10.0),
            maxHealthLabel.centerYAnchor.constraint(equalTo: currentHealthLabel.centerYAnchor),

            reloadButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            reloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            reloadButton.widthAnchor.constraint(equalToConstant: 50.0),
            reloadButton.heightAnchor.constraint(equalTo: reloadButton.widthAnchor),

            settingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30.0),
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            settingsButton.widthAnchor.constraint(equalToConstant: 100.0),
            settingsButton.heightAnchor.constraint(equalToConstant: 44.0),
            ])

        reset()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        let superWidth = view.frame.width
        let superHeight = view.frame.height
        let buttonWidth = min(superWidth * 0.28, 150.0)
        let buttonHeight = buttonWidth * 0.37
        let centerX = superWidth / 2.0

        skeletonBackgroundImage.frame = CGRect(x: 0, y: 10.0, width: superWidth, height: superHeight - 20.0)
        headButton.frame = CGRect(x: superWidth * 0.65, y: skeletonBackgroundImage.frame.size.height * 0.04, width: buttonWidth, height: buttonHeight)
        thoraxButton.frame = CGRect(x: centerX - (buttonWidth / 2.0), y: skeletonBackgroundImage.frame.size.height * 0.20, width: buttonWidth, height: buttonHeight)
        stomachButton.frame = CGRect(x: centerX - (buttonWidth / 2.0), y: skeletonBackgroundImage.frame.size.height * 0.33, width: buttonWidth, height: buttonHeight)
        rightArmButton.frame = CGRect(x: (stomachButton.frame.origin.x / 2.0) - (buttonWidth / 2.0), y: stomachButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        leftArmButton.frame = CGRect(x: stomachButton.frame.maxX + (stomachButton.frame.minX - rightArmButton.frame.maxX), y: stomachButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        rightLegButton.frame = CGRect(x: rightArmButton.frame.midX, y: skeletonBackgroundImage.frame.size.height * 0.60, width: buttonWidth, height: buttonHeight)
        leftLegButton.frame = CGRect(x: leftArmButton.frame.midX - buttonWidth, y: skeletonBackgroundImage.frame.size.height * 0.60, width: buttonWidth, height: buttonHeight)
    }

    @objc func reset() {
        target = Person(.pmc)
    }

    @objc func showSettings() {
        if let options = ammoOptions {
            let selectAmmoVC = SortableTableViewController(selectionDelegate: self, config: AmmoSortConfig(options: options), currentSelection: ammo)
            let nc = BaseNavigationController(rootViewController: selectAmmoVC)
            present(nc, animated: true, completion: nil)
        } else {
            let hud = JGProgressHUD(style: .dark)
            hud.position = .center
            hud.show(in: self.view)

            DependencyManagerImpl.shared.databaseManager().getAllAmmo { allAmmo in
                hud.dismiss(animated: false)

                self.ammoOptions = allAmmo
                self.showSettings()
            }
        }
    }

    @objc func handleHeadshot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.head, with: ammo) }
    }

    @objc func handleThoraxShot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.thorax, with: ammo) }
    }

    @objc func handleStomachShot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.stomach, with: ammo) }
    }

    @objc func handleLeftArmShot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.leftArm, with: ammo) }
    }

    @objc func handleRightArmShot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.rightArm, with: ammo) }
    }

    @objc func handleLeftLegShot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.leftLeg, with: ammo) }
    }

    @objc func handleRightLegShot() {
        if let ammo = ammo, let target = target { calculator.processImpact(to: target, on: target.rightLeg, with: ammo) }
    }

    func healthCalculator(_ calculator: HealthCalculator, processedImpact: BallisticsImpact) {
        target = processedImpact.target
    }

    // MARK: Sort selection delegate
    func itemSelected(_ selection: Sortable) {
        switch selection {
        case let selectedAmmo as Ammo: ammo = selectedAmmo
        default: fatalError()
        }

        dismiss(animated: true, completion: nil)
    }

    func selectionCancelled() {
        dismiss(animated: true, completion: nil)
    }
}
