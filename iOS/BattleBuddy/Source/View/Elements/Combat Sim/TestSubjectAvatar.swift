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
            characterImageView.sd_setImage(with: firebaseManager.avatarImageReference(characterId: characterId), placeholderImage: characterImageView.image)
        }
    }
    let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(white: 0.6, alpha: 1.0)
        imageView.image = UIImage(named: "placeholder_avatar")?.withRenderingMode(.alwaysTemplate)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
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

        addSubview(characterImageView)

        characterImageView.pinToContainer()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2.0
    }
}
