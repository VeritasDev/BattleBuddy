//
//  LocalizationUtils.swift
//  BattleBuddy
//
//  Created by Mike on 7/1/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

internal func Localized(_ key: String, args: [CVarArg] = []) -> String {
    return NSLocalizedString(key, comment: "")
}

extension String {
    func local() -> String {
        return NSLocalizedString(self, comment: "")
    }

    func local(args: [CVarArg]) -> String {
        return String(format: self.local(), arguments: args)
    }
}
