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

    let accountManager: AccountManager
    let databaseManager: DatabaseManager
    let httpRequestor: HttpRequestor
    let firebaseManager: FirebaseManager
    let prefsManager: PreferencesManager
    let twitchManager: TwitchManager
    let feedbackManager: FeedbackManager
    let adManager: AdManager
    let metadataManager: GlobalMetadataManager
    let ammoUtilitiesManager: AmmoUtilitiesManager

    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError() }

        // Firebase handles sessions, accounts, storage, metadata, and ads.
        let firebase = FirebaseManager(sessionDelegate: appDelegate)
        firebaseManager = firebase
        databaseManager = firebase
        adManager = firebase
        accountManager = firebase
        metadataManager = firebase

        httpRequestor = AlamofireManager()

        prefsManager = PreferencesManager()
        twitchManager = TwitchManager()
        feedbackManager = FeedbackManager()
        ammoUtilitiesManager = AmmoUtilitiesManagerImpl()
    }
}
