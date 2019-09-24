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
    func localeManager() -> LocaleManager
    func weaponBuildController() -> WeaponBuildController
}

// MARK:- Networking

protocol HttpRequestor {
    func sendGetRequest(url: String, headers: [String: String], completion: @escaping (_ : [String: Any]?) -> Void)
}

// MARK:- Session

enum AccountProperty: String {
    case lastLogin = "lastLogin"
    case loyalty = "loyalty"
    case nickname = "nickname"
}

protocol SessionDelegate {
    func sessionDidFinishLoading()
}

protocol AccountManager {
    func initializeSession()
    func isLoggedIn() -> Bool
    func currentUserMetadata() -> BBUser?
    func getValueForAccountProperty(_ property: AccountProperty, completion: @escaping (_ : Any?) -> Void)
    func updateAccountProperties(_ : [AccountProperty: Any], completion: @escaping (_ : Bool) -> Void)
    func refreshUserMetadata(_ : @escaping (_ : BBUser?) -> Void)
    func addLoyaltyPoints(_ points: Int)
}

// MARK: - Database

protocol DatabaseManager {
    func getAllItemsWithSearchQuery(_ query: String, handler: @escaping (_: [BaseItem]) -> Void)

    func getAllFirearms(handler: @escaping (_: [Firearm]) -> Void)
    func getAllArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllBodyArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllHelmets(handler: @escaping (_: [Armor]) -> Void)
    func getAllHelmetArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllAmmo(handler: @escaping (_: [Ammo]) -> Void)
    func getAllMedical(handler: @escaping (_: [Medical]) -> Void)
    func getAllThrowables(handler: @escaping (_: [Throwable]) -> Void)
    func getAllMelee(handler: @escaping (_: [MeleeWeapon]) -> Void)

    func getAllFirearmsByType(handler: @escaping ([FirearmType: [Firearm]]) -> Void)
    func getAllArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllBodyArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllHelmetsByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllHelmetArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllAmmoByCaliber(handler: @escaping ([String: [Ammo]]) -> Void)
    func getAllMedicalByType(handler: @escaping ([MedicalItemType: [Medical]]) -> Void)

    func getAllFirearmsOfType(type: FirearmType, handler: @escaping ([Firearm]) -> Void)
    func getAllFirearmsOfCaliber(caliber: String, handler: @escaping ([Firearm]) -> Void)
    func getAllAmmoOfCaliber(caliber: String, handler: @escaping ([Ammo]) -> Void)
    func getAllBodyArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void)
    func getAllBodyArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void)
    func getAllHelmetsOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void)
    func getAllHelmetsWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void)
    func getAllHelmetArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void)
    func getAllHelmetArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void)
}

// MARK:- Ads

enum VideoAdState {
    case unavailable
    case idle
    case loading
    case ready
}

protocol AdDelegate {
    func adManager(_ adManager: AdManager, didUpdate videoAdState: VideoAdState)
}

protocol AdManager {
    var adDelegate: AdDelegate? { get set }
    var currentVideoAdState: VideoAdState { get }
    func loadVideoAd()
    func bannerAdsEnabled() -> Bool
    func updateBannerAdsSetting(_ enabled: Bool)
    func watchAdVideo(from rootVC: UIViewController)
    func addBannerToView(_ view: UIView)
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

// MARK:- Locale

struct LanguageSetting {
    let code: String
    let displayName: String
}

protocol LocaleManager {
    func supportedLanguages() -> [LanguageSetting]
    func currentLanguageDisplayName() -> String
}
