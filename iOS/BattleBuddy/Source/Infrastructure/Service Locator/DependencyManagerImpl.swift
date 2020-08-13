//
//  DependencyManager.swift
//  BattleBuddy
//
//  Created by Mike on 6/2/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class DependencyManagerImpl: DependencyManager {
    static let shared: DependencyManager = DependencyManagerImpl()

    var pushNotificationMngr: PushNotificationManager?
    var accountMngr: AccountManager?
    var dbMngr: DatabaseManager?
    var httpRqstr: HttpRequestor?
    var firebaseMngr: FirebaseManager?
    var prefsMngr: PreferencesManager?
    var twitchMngr: TwitchManager?
    var feedbackMngr: FeedbackManager?
    var metadataMngr: GlobalMetadataManager?
    var ammoUtilitiesMngr: AmmoUtilitiesManager?
    var deviceMngr: DeviceManager?
    var localeMngr: LocaleManager?
    var iapMngr: IAPManager?

    func assembleDependencies(_ appDelegate: AppDelegate) {
        // Firebase handles sessions, accounts, storage, and metadata
        let firebase = FirebaseManager(sessionDelegate: appDelegate)
        pushNotificationMngr = firebase
        firebaseMngr = firebase
        dbMngr = firebase
        accountMngr = firebase
        metadataMngr = firebase

        httpRqstr = AlamofireManager()

        prefsMngr = PreferencesManager()
        twitchMngr = TwitchManager()
        feedbackMngr = FeedbackManagerImpl()
        ammoUtilitiesMngr = AmmoUtilitiesManagerImpl()
        deviceMngr = DeviceManagerImpl()
        localeMngr = LocaleManagerImpl()
        iapMngr = IAPManagerImpl()
    }

    func pushNotificationManager() -> PushNotificationManager { return pushNotificationMngr! }
    func accountManager() -> AccountManager { return accountMngr! }
    func databaseManager() -> DatabaseManager { return dbMngr! }
    func httpRequestor() -> HttpRequestor { return httpRqstr! }
    func firebaseManager() -> FirebaseManager { return firebaseMngr! }
    func prefsManager() -> PreferencesManager { return prefsMngr! }
    func twitchManager() -> TwitchManager { return twitchMngr! }
    func feedbackManager() -> FeedbackManager { return feedbackMngr! }
    func metadataManager() -> GlobalMetadataManager { return metadataMngr! }
    func ammoUtilitiesManager() -> AmmoUtilitiesManager { return ammoUtilitiesMngr! }
    func deviceManager() -> DeviceManager { return deviceMngr! }
    func localeManager() -> LocaleManager { return localeMngr! }
    func iapManager() -> IAPManager { return iapMngr! }
}
