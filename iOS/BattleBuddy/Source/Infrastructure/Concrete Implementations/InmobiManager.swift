//
//  InmobiManager.swift
//  BattleBuddy
//
//  Created by Veritas on 9/16/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit
import InMobiSDK

class InmobiManager: NSObject, AdManager {
    var adDelegate: AdDelegate?
    var currentVideoAdState: VideoAdState = .idle
    let accountId = "1ca74bc970374286b43eb23451514f6d"
    let consentData: [AnyHashable: Any] = [IM_GDPR_CONSENT_AVAILABLE: "true", "gdpr": 1]
    lazy var video: IMInterstitial = IMInterstitial(placementId: 1567297909039, delegate: self)

    override init() {
        super.init()

        IMSdk.initWithAccountID(accountId, consentDictionary: consentData)
        //IMSdk.setLogLevel(IMSDKLogLevel.debug)
    }

    func loadVideoAd() {
        switch currentVideoAdState {
        case .idle:
            print("Currently idle... Loading ad now.")
            video.load()
        default:
            print("Current state is \(currentVideoAdState), unable to load video ad.")
        }
    }

    func bannerAdsEnabled() -> Bool {
        return false
    }

    func updateBannerAdsSetting(_ enabled: Bool) {

    }

    func watchAdVideo(from rootVC: UIViewController) {
        print("Showing video ad...")
        video.show(from: rootVC)
        self.adDelegate?.adManager(self, didUpdate: .unavailable)
    }
}

extension InmobiManager: IMInterstitialDelegate {
    func interstitialDidReceiveAd(_ interstitial: IMInterstitial!) {
        print("Interstitial did receive ad!")
    }

    func interstitialDidFinishLoading(_ interstitial: IMInterstitial!) {
        print("Interstitial finished loading!")

        self.adDelegate?.adManager(self, didUpdate: .ready)
    }

    func interstitial(_ interstitial: IMInterstitial!, didFailToLoadWithError error: IMRequestStatus!) {
        print("Interstitial failed to load: ", error)

        self.adDelegate?.adManager(self, didUpdate: .unavailable)
        reloadVideoAd(after: 21.0)
    }

    func interstitial(_ interstitial: IMInterstitial!, didFailToPresentWithError error: IMRequestStatus!) {
        print("Interstitial failed to present: ", error)

        self.adDelegate?.adManager(self, didUpdate: .unavailable)
        reloadVideoAd(after: 21.0)
    }

    func interstitialDidDismiss(_ interstitial: IMInterstitial!) {
        print("Interstial dismissed.")

        self.adDelegate?.adManager(self, didUpdate: .idle)
        reloadVideoAd(after: 3)
    }

    func interstitial(_ interstitial: IMInterstitial!, rewardActionCompletedWithRewards rewards: [AnyHashable : Any]!) {
        print("Rewards received!")

        DependencyManagerImpl.shared.accountManager().addLoyaltyPoints(1)
    }

    func reloadVideoAd(after delay: Double = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.adDelegate?.adManager(self, didUpdate: .loading)
            self.video.load()
        }
    }
}
