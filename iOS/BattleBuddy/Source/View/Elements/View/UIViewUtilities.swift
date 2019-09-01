//
//  UIViewUtilities.swift
//  BattleBuddy
//
//  Created by Mike on 7/9/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

extension UIView {
    // tEmP hAcK zOmG Fix Plz
    func isCompactWidth() -> Bool {
        return UIApplication.shared.keyWindow?.rootViewController?.traitCollection.horizontalSizeClass == .compact
    }

    func constrainHeight(_ height: CGFloat) {
        NSLayoutConstraint.activate([ self.heightAnchor.constraint(equalToConstant: height) ])
    }

    func constrainWidth(_ width: CGFloat) {
        NSLayoutConstraint.activate([ self.widthAnchor.constraint(equalToConstant: width) ])
    }

    func constrainSize(_ size: CGSize) {
        NSLayoutConstraint.activate([ self.widthAnchor.constraint(equalToConstant: size.width), self.heightAnchor.constraint(equalToConstant: size.height) ])
    }

    func pinToTop(xInset: CGFloat = 0.0, yInset: CGFloat = 0.0, height: CGFloat) {
        guard let superview = superview else { fatalError() }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: xInset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -xInset),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: yInset),
            heightAnchor.constraint(equalToConstant: height)
            ])
    }

    func pinToBottom(xInset: CGFloat = 0.0, yInset: CGFloat = 0.0, height: CGFloat) {
        guard let superview = superview else { fatalError() }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: xInset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -xInset),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -yInset),
            heightAnchor.constraint(equalToConstant: height)
            ])
    }

    func pinToContainer(xInset: CGFloat = 0.0, yInset: CGFloat = 0.0) {
        guard let superview = superview else { fatalError() }

        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: xInset),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -xInset),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: yInset),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -yInset),
            ])
    }
}

extension NSLayoutConstraint {
    func deactivateAndCreateNewActivated(multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        let newConstraint = NSLayoutConstraint(item: firstItem!, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}

extension UIStackView {
    func addBackgroundView() -> UIView {
        let backgroundView = UIView(frame: bounds)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(backgroundView, at: 0)
        return backgroundView
    }
}
