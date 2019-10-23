//
//  CombatSimLabels.swift
//  BattleBuddy
//
//  Created by Veritas on 10/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class CombatSimResultKeyLabel: UILabel {
    required init?(coder aDecoder: NSCoder) { fatalError() }

    init(key: String) {
        super.init(frame: .zero)

        text = key
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 14.0, weight: .thin)
        textColor = UIColor.init(white: 0.7, alpha: 1.0)
    }
}

class CombatSimResultValueLabel: UILabel {
    required init?(coder aDecoder: NSCoder) { fatalError() }

    init() {
        super.init(frame: .zero)

        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: 16.0)
        textColor = .white
        text = "-"
    }
}
