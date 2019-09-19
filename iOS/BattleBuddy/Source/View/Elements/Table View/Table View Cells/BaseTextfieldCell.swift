//
//  BaseTextfieldCell.swift
//  BattleBuddy
//
//  Created by Veritas on 9/18/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseTextfieldCell: BaseTableViewCell {
    let textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.textColor = .white
        textField.tintColor = UIColor(white: 0.8, alpha: 1.0)
        textField.font = UIFont.systemFont(ofSize: 18.0)
        return textField
    }()

    required init?(coder: NSCoder) { fatalError() }

    init() {
        super.init(style: .default, reuseIdentifier: nil)

        contentView.addSubview(textField)

        textField.pinToContainer(xInset: 20.0, yInset: 3.0)
    }
}
