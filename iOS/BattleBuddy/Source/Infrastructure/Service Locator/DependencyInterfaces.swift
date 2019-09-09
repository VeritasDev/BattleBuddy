//
//  DependencyInterfaces.swift
//  BattleBuddy
//
//  Created by Mike on 7/30/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import UIKit

// Mark:- Dependency Manager

protocol DependencyManager {
    static var shared: DependencyManager { get }
    func assembleDependencies(_ appDelegate: AppDelegate)
    func accountManager() -> AccountManager
    func databaseManager() -> DatabaseManager
    func httpRequestor() -> HttpRequestor
    func firebaseManager() -> FirebaseManager
    func prefsManager() -> PreferencesManager
    func twitchManager() -> TwitchManager
    func feedbackManager() -> FeedbackManager
    func adManager() -> AdManager
    func metadataManager() -> GlobalMetadataManager
    func ammoUtilitiesManager() -> AmmoUtilitiesManager
    func deviceManager() -> DeviceManager
}

// MARK:- Networking

protocol HttpRequestor {
    func sendGetRequest(url: String, headers: [String: String], completion: @escaping (_ : [String: Any]?) -> Void)
}

// MARK:- Session

enum AccountProperty: String {
    case lastLogin = "lastLogin"
    case adsWatched = "adsWatched"
}

protocol SessionDelegate {
    func sessionDidFinishLoading()
}

protocol AccountManager {
    func initializeSession()
    func isLoggedIn() -> Bool
    func getValueForAccountProperty(_ property: AccountProperty, completion: @escaping (_ : Any?) -> Void)
    func updateAccountProperties(_ : [AccountProperty: Any])
}

// MARK: - Database

protocol DatabaseManager {
    func getAllItemsWithSearchQuery(_ query: String, handler: @escaping (_: [BaseItem]) -> Void)

    func getAllFirearms(handler: @escaping (_: [Firearm]) -> Void)
    func getAllArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllBodyArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllAmmo(handler: @escaping (_: [Ammo]) -> Void)
    func getAllMedical(handler: @escaping (_: [Medical]) -> Void)
    func getAllThrowables(handler: @escaping (_: [Throwable]) -> Void)
    func getAllMelee(handler: @escaping (_: [MeleeWeapon]) -> Void)

    func getAllFirearmsByType(handler: @escaping ([FirearmType: [Firearm]]) -> Void)
    func getAllArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllBodyArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllAmmoByCaliber(handler: @escaping ([String: [Ammo]]) -> Void)
    func getAllMedicalByType(handler: @escaping ([MedicalItemType: [Medical]]) -> Void)

    func getAllFirearmsOfType(type: FirearmType, handler: @escaping ([Firearm]) -> Void)
    func getAllFirearmsOfCaliber(caliber: String, handler: @escaping ([Firearm]) -> Void)
    func getAllAmmoOfCaliber(caliber: String, handler: @escaping ([Ammo]) -> Void)
    func getAllBodyArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void)
    func getAllBodyArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void)
}

// MARK:- Ads

enum VideoAdState {
    case unavailable
    case loading
    case ready
}

protocol AdDelegate {
    func adManager(_ adManager: AdManager, didUpdate videoAdState: VideoAdState)
}

protocol AdManager {
    var adDelegate: AdDelegate? { get set }
    var currentVideoAdState: VideoAdState { get }
    func bannerAdsEnabled() -> Bool
    func updateBannerAdsSetting(_ enabled: Bool)
    func watchAdVideo(from rootVC: UIViewController)
}

// MARK:- Global Metadata

struct AmmoMetadata {
    let caliber: String
    let displayName: String
    let index: Int
}

struct GlobalMetadata {
    let totalUserCount: Int
    let totalAdsWatched: Int
    let ammoMetadata: [AmmoMetadata]

    init?(json: [String: Any]) {
        guard let ammoMeta = json["ammoMetadata"] as? [String: [String: Any]], let boxedUserCount = json["totalUserCount"] as? NSNumber, let boxedAdCount = json["totalAdsWatched"] as? NSNumber else {
            return nil
        }

        var tempAmmoMeta: [AmmoMetadata] = []
        for caliber in ammoMeta.keys {
            guard let data = ammoMeta[caliber], let displayName = data["displayName"] as? String,
                let rawIndex = data["index"] as? NSNumber else {
                return nil
            }

            tempAmmoMeta.append(AmmoMetadata(caliber: caliber, displayName: displayName, index: rawIndex.intValue))
        }

        totalUserCount = boxedUserCount.intValue
        totalAdsWatched = boxedAdCount.intValue
        ammoMetadata = tempAmmoMeta
    }
}

protocol GlobalMetadataManager {
    func getGlobalMetadata() -> GlobalMetadata?
    func updateGlobalMetadata(handler: @escaping (_ : GlobalMetadata?) -> Void)
}

// Mark:- Ammo Manager

protocol AmmoUtilitiesManager {
    func caliberDisplayName(_ caliber: String) -> String
}

// Mark:- Feedback

protocol FeedbackManager {
    func promptForReviewIfNecessary()
    func canAskForReview() -> Bool
    func askForReview()
}

// MARK:- Device

protocol DeviceManager {
    func appVersionString() -> String?
}
