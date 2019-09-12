//
//  BaseCardCell.swift
//  BattleBuddy
//
//  Created by Mike on 6/28/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class BaseCardCell: UICollectionViewCell {
    private let baseCardCellPadding: CGFloat = 10.0
    internal let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Theme.background
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    var disabledHighlightedAnimation = false

    required init?(coder aDecoder: NSCoder) { fatalError("NIMP") }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .init(width: 0, height: 4)

        contentView.addSubview(containerView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let containerSize = CGSize.init(width: contentView.frame.width - (2 * baseCardCellPadding), height: contentView.frame.height - (2 * baseCardCellPadding))
        containerView.frame = CGRect.init(x: baseCardCellPadding, y: baseCardCellPadding, width: containerSize.width, height: containerSize.height)

        layer.shadowRadius = containerView.frame.width * 0.03
    }

    // Make it appears very responsive to touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animate(isHighlighted: true)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        animate(isHighlighted: false)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        animate(isHighlighted: false)
    }

    private func animate(isHighlighted: Bool, completion: ((Bool) -> Void)?=nil) {
        if disabledHighlightedAnimation { return }
        let transform: CGAffineTransform = isHighlighted ? .init(scaleX: 0.96, y: 0.96) : .identity
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: [.allowUserInteraction],
                       animations: {
                        self.transform = transform
        }, completion: completion)
    }
}
