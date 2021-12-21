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
    func assembleDependencies(_ appDelegate: SessionDelegate)
    func pushNotificationManager() -> PushNotificationManager
    func accountManager() -> AccountManager
    func databaseManager() -> DatabaseManager
    func httpRequestor() -> HttpRequestor
    func firebaseManager() -> FirebaseManager
    func prefsManager() -> PreferencesManager
    func twitchManager() -> TwitchManager
    func feedbackManager() -> FeedbackManager
    func metadataManager() -> GlobalMetadataManager
    func ammoUtilitiesManager() -> AmmoUtilitiesManager
    func deviceManager() -> DeviceManager
    func localeManager() -> LocaleManager
}

// MARK:- Networking

protocol HttpRequestor {
    func sendGetRequest(url: String, headers: [String: String], completion: @escaping (_ : [String: Any]?) -> Void)
}

// MARK:- Account
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
    func addLoyaltyPoints(_ points: Int, completion: @escaping () -> Void)
    func nextAvailableBudPointsReward() -> BudPointsReward
    func redeemBudPoints(completion: @escaping () -> Void)
}

// MARK: - Database
protocol DatabaseManager {
//    func getAppNews(handler: @escaping (_: NewsPost?) -> Void)
    func getCharacters(handler: @escaping (_: [Character]) -> Void)

    func getAllItemsWithSearchQuery(_ query: String, handler: @escaping (_: [BaseItem]) -> Void)

    func getAllFirearms(handler: @escaping (_: [Firearm]) -> Void)
    func getAllArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllBodyArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllChestRigs(handler: @escaping (_: [ChestRig]) -> Void)
    func getAllArmoredChestRigs(handler: @escaping (_: [ChestRig]) -> Void)
    func getAllHeadArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllHelmets(handler: @escaping (_: [Armor]) -> Void)
    func getAllHelmetArmor(handler: @escaping (_: [Armor]) -> Void)
    func getAllAmmo(handler: @escaping (_: [Ammo]) -> Void)
    func getAllMedical(handler: @escaping (_: [Medical]) -> Void)
    func getAllThrowables(handler: @escaping (_: [Throwable]) -> Void)
    func getAllMelee(handler: @escaping (_: [MeleeWeapon]) -> Void)

    func getAllMarketItems(handler: @escaping (_: [MarketItem]) -> Void)

    func getAllFirearmsByType(handler: @escaping ([FirearmType: [Firearm]]) -> Void)
    func getAllArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllBodyArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void)
    func getAllChestRigsByClass(handler: @escaping ([ArmorClass: [ChestRig]]) -> Void)
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

protocol PushNotificationManager {
    func enablePushNotifications(enabled: Bool)
    func pushNotificationsEnabled(handler: @escaping (_ : Bool) -> Void)
}
