//
//  DeviceManagerImpl.swift
//  BattleBuddy
//
//  Created by Mike on 9/9/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation

struct DeviceManagerImpl: DeviceManager {
    func appVersionString() -> String? {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            return "v" + appVersion
        } else {
            return nil
        }
    }
}
