//
//  BaseTableViewCell.swift
//  BattleBuddy
//
//  Created by Mike on 7/9/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    var height: CGFloat = UITableView.automaticDimension

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(white: 0.05, alpha: 1.0)
        textLabel?.textColor = UIColor(white: 0.9, alpha: 1.0)
        detailTextLabel?.textColor = .white
        tintColor = UIColor.Theme.primary
    }

    convenience init(text: String? = nil, accessory: UITableViewCell.AccessoryType = .disclosureIndicator, selection: UITableViewCell.SelectionStyle = .gray) {
        self.init(style: .value1, reuseIdentifier: nil)

        textLabel?.text = text
        textLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        textLabel?.numberOfLines = 0
        detailTextLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        detailTextLabel?.numberOfLines = 0
        accessoryType = accessory
        selectionStyle = selection
        isUserInteractionEnabled = selection != .none
        tintColor = UIColor.Theme.primary
    }

    convenience init(style: UITableViewCell.CellStyle = .subtitle, text: String? = nil, detailText: String? = nil, accessory: UITableViewCell.AccessoryType = .none, selection: UITableViewCell.SelectionStyle = .gray) {
        self.init(style: style, reuseIdentifier: nil)

        textLabel?.text = text
        textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        textLabel?.numberOfLines = 0
        detailTextLabel?.text = detailText
        detailTextLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        detailTextLabel?.numberOfLines = 0
        accessoryType = accessory
        selectionStyle = selection
        isUserInteractionEnabled = selection != .none
        tintColor = UIColor.Theme.primary
    }
}
