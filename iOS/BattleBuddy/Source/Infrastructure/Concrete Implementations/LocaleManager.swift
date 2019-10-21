//
//  LocaleManager.swift
//  BattleBuddy
//
//  Created by Veritas on 9/15/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

class LocaleManagerImpl: LocaleManager {
    let prefsManager = DependencyManagerImpl.shared.prefsManager()
    let supportedLanguageCodes = ["en", "hu", "sv", "nl", "hr", "es", "es-419", "ru", "sr", "sr-Latn", "it", "pt-BR", "lt", "ar", "fr", "pt-PT", "id", "pl", "zh-Hant", "de", "et", "ko", "nb", "cs", "sl", "ja"]

    func supportedLanguages() -> [LanguageSetting] {
        let settings = supportedLanguageCodes.map { LanguageSetting(code: $0, displayName: fallbackDisplayNameForLanguageCode($0)) }
        return settings.sorted { $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == ComparisonResult.orderedAscending }
    }

    func currentLanguageDisplayName() -> String {
        if let languageCode = prefsManager.valueForStringPref(.languageOverride) {
            return Locale.autoupdatingCurrent.localizedString(forLanguageCode: languageCode) ?? fallbackDisplayNameForLanguageCode(languageCode)
        } else {
            return "language_system_default".local()
        }
    }

    func fallbackDisplayNameForLanguageCode(_ code: String) -> String {
        let map: [String: String] = [
            "en" : "English",
            "hu" : "Hungarian",
            "sv" : "Swedish",
            "nl" : "Dutch",
            "hr" : "Croatian",
            "es-419" : "Spanish (Latin America)",
            "ru" : "Russian",
            "sr" : "Serbian",
            "sr-Latn" : "Serbian (Latin)",
            "es" : "Spanish (Spain)",
            "it" : "Italian",
            "pt-BR" : "Portuguese (Brazil)",
            "lt" : "Lithuanian",
            "ar" : "Arabic",
            "fr" : "French",
            "pt-PT" : "Portguguese (Portgual)",
            "id" : "Indonesian",
            "pl" : "Polish",
            "zh-Hant" : "Chinese",
            "de" : "German",
            "et" : "Estonian",
            "ko" : "Korean",
            "nb" : "Norwegian",
            "cs": "Czech",
            "sl": "Slovenian",
            "ja": "Japanese"
        ]

        guard let displayName = map[code] else { fatalError() }
        return displayName
    }
}
