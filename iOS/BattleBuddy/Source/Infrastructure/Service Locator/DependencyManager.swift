//
//  DependencyManager.swift
//  BattleBuddy
//
//  Created by Mike on 6/2/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

class DependencyManager {
    static let shared = DependencyManager()

    let sessionManager: SessionManager
    let databaseManager: DatabaseManager
    let httpRequestor: HttpRequestor
    let firebaseManager: FirebaseManager
    let statsManager: StatsManager
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
        sessionManager = firebase
        metadataManager = firebase

        httpRequestor = AlamofireManager()
        statsManager = StatsManagerImpl()
        prefsManager = PreferencesManager()
        twitchManager = TwitchManager()
        feedbackManager = FeedbackManager()
        ammoUtilitiesManager = AmmoUtilitiesManagerImpl()
    }
}
