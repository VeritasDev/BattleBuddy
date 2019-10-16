//
//  TestSubjectAvatar.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import BallisticsEngine

class TestSubjectAvatar: UIButton {
    let firebaseManager = DependencyManagerImpl.shared.firebaseManager()
    var characterId: String? {
        didSet {
            guard let characterId = characterId else { return }
            imageView?.sd_setImage(with: firebaseManager.avatarImageReference(characterId: characterId), placeholderImage: imageView?.image, completion: { (image, error, cacheType, storageRef) in
                self.setImage(image, for: .normal)
            })
        }
    }
    var result: CombatSimulationResult? {
        didSet {
            switch result {
            case .win?:
                layer.borderColor = UIColor.green.cgColor
                alpha = 1.0
            case .loss?:
                layer.borderColor = UIColor.red.cgColor
                alpha = 0.5
            default:
                layer.borderColor = UIColor.white.cgColor
                alpha = 1.0
            }
        }
    }

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(frame: .zero)

        backgroundColor = .black
        clipsToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.white.cgColor

        let placeholderImage = UIImage(named: "placeholder_avatar")?.withRenderingMode(.alwaysTemplate)
        setImage(placeholderImage, for: .normal)
        imageView?.tintColor = UIColor(white: 0.6, alpha: 1.0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2.0
    }
}
