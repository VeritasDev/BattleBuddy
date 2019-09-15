//
//  LocalizationUtils.swift
//  BattleBuddy
//
//  Created by Mike on 7/1/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

internal func Localized(_ key: String, args: [CVarArg] = []) -> String {
    if let lang = DependencyManagerImpl.shared.prefsManager().valueForStringPref(.languageOverride) {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(key, tableName: nil, bundle: bundle!, value: "", comment: "")
    }

    return NSLocalizedString(String(format: key, arguments: args), comment: "")
}

extension String {
    func local() -> String {
        if let lang = DependencyManagerImpl.shared.prefsManager().valueForStringPref(.languageOverride) {
            let path = Bundle.main.path(forResource: lang, ofType: "lproj")
            let bundle = Bundle(path: path!)
            return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        } else {
            return NSLocalizedString(self, comment: "")
        }
    }

    func local(args: [CVarArg]) -> String {
        return String(format: self.local(), arguments: args)
    }
}
