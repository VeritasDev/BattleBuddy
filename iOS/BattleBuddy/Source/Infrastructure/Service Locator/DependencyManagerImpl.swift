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

    var accountMngr: AccountManager?
    var dbMngr: DatabaseManager?
    var httpRqstr: HttpRequestor?
    var firebaseMngr: FirebaseManager?
    var prefsMngr: PreferencesManager?
    var twitchMngr: TwitchManager?
    var feedbackMngr: FeedbackManager?
    var adMngr: AdManager?
    var metadataMngr: GlobalMetadataManager?
    var ammoUtilitiesMngr: AmmoUtilitiesManager?
    var deviceMngr: DeviceManager?

    func assembleDependencies(_ appDelegate: AppDelegate) {
        // Firebase handles sessions, accounts, storage, metadata, and ads.
        let firebase = FirebaseManager(sessionDelegate: appDelegate)
        firebaseMngr = firebase
        dbMngr = firebase
        adMngr = firebase
        accountMngr = firebase
        metadataMngr = firebase

        httpRqstr = AlamofireManager()

        prefsMngr = PreferencesManager()
        twitchMngr = TwitchManager()
        feedbackMngr = FeedbackManagerImpl()
        ammoUtilitiesMngr = AmmoUtilitiesManagerImpl()
        deviceMngr = DeviceManagerImpl()
    }

    func accountManager() -> AccountManager { return accountMngr! }
    func databaseManager() -> DatabaseManager { return dbMngr! }
    func httpRequestor() -> HttpRequestor { return httpRqstr! }
    func firebaseManager() -> FirebaseManager { return firebaseMngr! }
    func prefsManager() -> PreferencesManager { return prefsMngr! }
    func twitchManager() -> TwitchManager { return twitchMngr! }
    func feedbackManager() -> FeedbackManager { return feedbackMngr! }
    func adManager() -> AdManager { return adMngr! }
    func metadataManager() -> GlobalMetadataManager { return metadataMngr! }
    func ammoUtilitiesManager() -> AmmoUtilitiesManager { return ammoUtilitiesMngr! }
    func deviceManager() -> DeviceManager { return deviceMngr! }
}
