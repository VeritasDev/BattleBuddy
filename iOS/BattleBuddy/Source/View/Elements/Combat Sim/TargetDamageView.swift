//
//  TargetDamageView.swift
//  BattleBuddy
//
//  Created by Veritas on 8/10/20.
//  Copyright © 2020 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class TargetDamageView: UIView {
    var enabled: Bool = false { didSet { enableButtons(enabled) } }
    var characterType: Character {
        didSet {
            avatar.characterId = characterType.id
            characterNameLabel.text = characterType.name
            setNeedsLayout()
        }
    }
    var target: BEPerson? {
        didSet {
            guard let newTarget = target else { return }

            avatar.result = newTarget.isAlive ? .none : .loss
            headButton.zone = newTarget.head
            thoraxButton.zone = newTarget.thorax
            stomachButton.zone = newTarget.stomach
            rightArmButton.zone = newTarget.armR
            leftArmButton.zone = newTarget.armL
            rightLegButton.zone = newTarget.legR
            leftLegButton.zone = newTarget.legL
            currentHealthLabel.text = String(Int(newTarget.totalCurrentHp))
            maxHealthLabel.text = "/ \(Int(newTarget.totalOriginalHp))"
            setNeedsLayout()
        }
    }

    let avatar = TestSubjectAvatar()
    let characterNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        return label
    }()
    let skeletonBackgroundImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "health_calc_skeleton")!)
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.1
        return imageView
    }()

    let containerStackView = BaseStackView(axis: .vertical)
    let topStackView = BaseStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing)
    let chestStackView = BaseStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing)
    let stomachStackView = BaseStackView(axis: .horizontal, alignment: .center, distribution: .equalCentering)
    let legsStackView = BaseStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing)
    let hpStackView = BaseStackView(axis: .horizontal, alignment: .center, distribution: .equalSpacing)
    lazy var stackViews = [topStackView, chestStackView, stomachStackView, legsStackView, hpStackView]

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
    lazy var zoneButtons = [headButton, thoraxButton, stomachButton, rightArmButton, leftArmButton, rightLegButton, leftLegButton]

    required init?(coder: NSCoder) { fatalError() }

    init(_ characterType: Character) {
        self.characterType = characterType
        
        super.init(frame: .zero)

        addSubview(skeletonBackgroundImage)
        addSubview(headButton)
        addSubview(thoraxButton)
        addSubview(stomachButton)
        addSubview(rightArmButton)
        addSubview(leftArmButton)
        addSubview(leftLegButton)
        addSubview(rightLegButton)
        addSubview(hpIconImageView)
        addSubview(currentHealthLabel)
        addSubview(maxHealthLabel)
        addSubview(avatar)
        addSubview(characterNameLabel)

        enableButtons(false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let superWidth = frame.width
        let superHeight = frame.height
        let buttonWidth = min(superWidth * 0.28, 150.0)
        let buttonHeight = buttonWidth * 0.37
        let centerX = superWidth / 2.0

        avatar.frame = CGRect(x: 20, y: 5, width: 60, height: 60)
        characterNameLabel.frame = CGRect(x: 10, y: avatar.frame.maxY + 7, width: 70, height: 0)
        characterNameLabel.sizeToFit()
        characterNameLabel.frame = CGRect(x: avatar.frame.midX - (characterNameLabel.frame.width / 2.0), y: avatar.frame.maxY + 7, width: characterNameLabel.frame.width, height: characterNameLabel.frame.height)


        skeletonBackgroundImage.frame = CGRect(x: 0, y: 10.0, width: superWidth, height: superHeight - 20.0)
        headButton.frame = CGRect(x: superWidth * 0.65, y: skeletonBackgroundImage.frame.size.height * 0.04, width: buttonWidth, height: buttonHeight)
        thoraxButton.frame = CGRect(x: centerX - (buttonWidth / 2.0), y: skeletonBackgroundImage.frame.size.height * 0.20, width: buttonWidth, height: buttonHeight)
        stomachButton.frame = CGRect(x: centerX - (buttonWidth / 2.0), y: skeletonBackgroundImage.frame.size.height * 0.33, width: buttonWidth, height: buttonHeight)
        rightArmButton.frame = CGRect(x: (stomachButton.frame.origin.x / 2.0) - (buttonWidth / 2.0), y: stomachButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        leftArmButton.frame = CGRect(x: stomachButton.frame.maxX + (stomachButton.frame.minX - rightArmButton.frame.maxX), y: stomachButton.frame.origin.y, width: buttonWidth, height: buttonHeight)
        rightLegButton.frame = CGRect(x: rightArmButton.frame.midX, y: skeletonBackgroundImage.frame.size.height * 0.60, width: buttonWidth, height: buttonHeight)
        leftLegButton.frame = CGRect(x: leftArmButton.frame.midX - buttonWidth, y: skeletonBackgroundImage.frame.size.height * 0.60, width: buttonWidth, height: buttonHeight)

        currentHealthLabel.sizeToFit()
        currentHealthLabel.frame = CGRect(x: centerX - (currentHealthLabel.frame.width / 2), y: leftLegButton.frame.maxY + 20, width: currentHealthLabel.frame.width, height: currentHealthLabel.frame.height)

        hpIconImageView.frame = CGRect(x: currentHealthLabel.frame.minX - 20 - 20, y: currentHealthLabel.frame.midY - 10, width: 20.0, height: 20.0)

        maxHealthLabel.sizeToFit()
        maxHealthLabel.frame = CGRect(x: currentHealthLabel.frame.maxX + 10.0, y: currentHealthLabel.frame.midY - (maxHealthLabel.frame.height / 2.0), width: maxHealthLabel.frame.width, height: maxHealthLabel.frame.height)
    }

    func enableButtons(_ enabled: Bool) {
        headButton.enable(enabled)
        thoraxButton.enable(enabled)
        stomachButton.enable(enabled)
        rightArmButton.enable(enabled)
        leftArmButton.enable(enabled)
        rightLegButton.enable(enabled)
        leftLegButton.enable(enabled)
    }
}
