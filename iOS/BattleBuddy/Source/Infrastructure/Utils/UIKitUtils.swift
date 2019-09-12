//
//  UIKitUtils.swift
//  BattleBuddy
//
//  Created by Mike on 8/7/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

extension UIViewController {
    func handleUrlString(_ urlString: String) {
        let app = UIApplication.shared

        if let url = URL(string: urlString), app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
            return
        }

        showOkAlert(message: "website_error".local())
    }

    func handleLink(_ link: Linkable) {
        let app = UIApplication.shared

        if let url: URL = link.deeplinkUrl(), app.canOpenURL(url) {
            app.open(url, options: [.universalLinksOnly: true], completionHandler: nil)
            return
        }

        if let backupUrl = link.regularUrl(), app.canOpenURL(backupUrl) {
            app.open(backupUrl, options: [:], completionHandler: nil)
            return
        }

        showOkAlert(message: "website_error".local())
    }

    func showOkAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".local(), style: .default, handler: nil))
        present(alert, animated: true, completion:nil)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
