//
//  PreviewMenuCell.swift
//  BattleBuddy
//
//  Created by Mike on 6/28/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class PreviewMenuCell: BaseCardCell {
    var displayableItem: Displayable? {
        didSet {
            previewView.displayableItem = displayableItem
        }
    }

    let previewView = PreviewMenuView()

    required init?(coder aDecoder: NSCoder) { fatalError() }

    override init(frame: CGRect) {
        super.init(frame: frame)

        containerView.addSubview(previewView)

        previewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: containerView.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            previewView.widthAnchor.constraint(equalTo: containerView.widthAnchor)
            ])
    }
}
