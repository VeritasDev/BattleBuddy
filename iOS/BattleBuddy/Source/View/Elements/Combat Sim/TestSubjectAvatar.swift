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
    var personType: PersonType? { didSet { setImage(personType?.avatarImage, for: .normal) } }
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
                layer.borderColor = UIColor.Theme.primary.cgColor
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
        layer.borderColor = UIColor.Theme.primary.cgColor
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2.0
    }
}
