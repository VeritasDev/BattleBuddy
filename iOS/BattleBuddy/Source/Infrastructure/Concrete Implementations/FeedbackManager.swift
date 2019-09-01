//
//  FeedbackManager.swift
//  BattleBuddy
//
//  Created by Mike on 8/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import StoreKit

class FeedbackManager {
    private let launchCountThreshold: Int = 3
    private let fourMonthsInSeconds: Double = 10_368_000.0;
    private let appRatingDelayPrompt: Double = 15.0;
    lazy var prefsManager = DependencyManager.shared.prefsManager

    // Require at least 3 launches before we automatically prompt users for a review, as well as
    // a 4-month minimum period in between prompts.
    func promptForReviewIfNecessary() {
        if !updateAndCheckCount() { return }
        if !canAskForReview() { return }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + appRatingDelayPrompt) {
            SKStoreReviewController.requestReview()
            self.updateRatingTimestamp()
        }
    }

    func canAskForReview() -> Bool {
        let previousReviewTimestamp = prefsManager.valueForDoublePref(.appRatingTimestamp)
        let currentTimestamp = NSDate().timeIntervalSince1970
        return currentTimestamp - previousReviewTimestamp > fourMonthsInSeconds
    }

    private func updateCheckCount() {
        let currentCheckCount = prefsManager.valueForIntPref(.appRatingCheckCount)
        prefsManager.update(.appRatingCheckCount, value: currentCheckCount + 1)
    }

    private func updateAndCheckCount() -> Bool {
        let newCount = prefsManager.valueForIntPref(.appRatingCheckCount) + 1
        prefsManager.update(.appRatingCheckCount, value: newCount)
        return newCount > launchCountThreshold
    }

    private func updateRatingTimestamp() {
        prefsManager.update(.appRatingTimestamp, value: NSDate().timeIntervalSince1970)
    }
}
