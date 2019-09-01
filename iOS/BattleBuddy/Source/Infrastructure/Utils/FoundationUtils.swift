//
//  FoundationUtils.swift
//  BattleBuddy
//
//  Created by Mike on 8/27/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

extension String {
    func containsIgnoringCase(_ find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }

    func createAttributedString(boldedSubstring: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (self as NSString).range(of: boldedSubstring)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
}
