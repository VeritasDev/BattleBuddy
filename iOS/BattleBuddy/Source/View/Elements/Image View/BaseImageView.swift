//
//  BaseImageView.swift
//  BattleBuddy
//
//  Created by Mike on 7/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
//import FirebaseUI

enum AspectRatioType {
    case standard
    case square
    case custom
}

// TODO: Resize assets for all resolutions!

class BaseImageView: UIImageView {
    let firebaseManager = DependencyManagerImpl.shared.firebaseManager()
    var displayableItem: Displayable? {
        didSet {
            if let displayable = displayableItem {
                tintColor = displayable.tint?.withAlphaComponent(0.45)
                sd_setImage(with: firebaseManager.itemImageReference(itemId: displayable.identifier, itemType: displayable.type, size: imageSize), placeholderImage: displayable.placeholderImage)
            } else {
                image = nil
            }
        }
    }
    let imageSize: ImageSize
    let aspectRatio: AspectRatioType
    required init?(coder: NSCoder) { fatalError() }

    init(imageSize: ImageSize, aspectRatio: AspectRatioType = .standard) {
        self.imageSize = imageSize
        self.aspectRatio = aspectRatio

        super.init(frame: .zero)

        contentMode = .scaleAspectFill
        clipsToBounds = true
        backgroundColor = UIColor.Theme.background
    }

    func configureForAspectRatio() {
        switch aspectRatio {
        case .standard:
            NSLayoutConstraint.activate([NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.56, constant: 0)])
        case .square:
            NSLayoutConstraint.activate([NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0)])
        case .custom:
            return // Do nothing here...
        }
    }
}
