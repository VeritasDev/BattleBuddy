//
//  WebKitUtils.swift
//  BattleBuddy
//
//  Created by Mike on 7/31/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import WebKit

class WebKitUtils {

    public static func clearWKWebViewCache(completionHandler: @escaping () -> Void) {
        WKWebsiteDataStore.default().removeData(ofTypes: Set(arrayLiteral: WKWebsiteDataTypeCookies),
                                                    modifiedSince: Date(timeIntervalSince1970: 0),
                                                    completionHandler: completionHandler)
    }
}
