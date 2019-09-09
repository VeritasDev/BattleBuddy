//
//  WatchAdCell.swift
//  BattleBuddy
//
//  Created by Mike on 8/30/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class WatchAdCell: BaseTableViewCell {
    var videoAdState: VideoAdState = .unavailable { didSet { updateVideoAdState() } }
    let accessory = UIActivityIndicatorView(style: .whiteLarge)

    required init?(coder: NSCoder) { fatalError() }

    init(iconHeight: CGFloat) {
        super.init(style: .default, reuseIdentifier: nil)

        textLabel?.text = "watch_ad".local()
        textLabel?.font = .systemFont(ofSize: 20, weight: .medium)

        imageView?.image = UIImage(named: "watch_ad")?.imageScaled(toFit: CGSize(width: iconHeight, height: iconHeight))

        accessory.hidesWhenStopped = true
        accessoryView = accessory

        updateVideoAdState()
    }

    func updateVideoAdState() {
        switch videoAdState {
        case .loading:
            accessory.startAnimating()
            accessory.alpha = 1.0
            contentView.alpha = 0.1
            isUserInteractionEnabled = false
        case .ready:
            accessory.stopAnimating()
            accessory.alpha = 1.0
            contentView.alpha = 1.0
            isUserInteractionEnabled = true
        case .unavailable:
            accessory.startAnimating()
            accessory.alpha = 0.4
            contentView.alpha = 0.1
            isUserInteractionEnabled = false
        }
    }
}
