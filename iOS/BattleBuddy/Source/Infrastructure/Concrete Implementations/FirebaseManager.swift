//
//  FirebaseManager.swift
//  BattleBuddy
//
//  Created by Mike on 7/8/19.
//  Copyright © 2019 Veritas. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

enum FirebaseCollection: String {
    case firearms = "firearm"
    case mods = "modification"
    case armor = "armor"
    case ammo = "ammunition"
    case medical = "medical"
    case throwables = "grenade"
    case melee = "melee"
    case global = "global"
    case users = "users"
    case compatibility = "compatibility"
    case character = "character"
    case news = "news"
}

enum ImageSize: String {
    case medium = "_medium.jpg"
    case large = "_large.jpg"
    case full = "_full.jpg"
    case avatar = "_avatar.png"
}

class FirebaseManager: NSObject {
    private lazy var db = Firestore.firestore()
    private lazy var storage = Storage.storage()
    private lazy var storageRef = storage.reference()
    private lazy var firearmsImageRef = storageRef.child("guns")
    private lazy var modsImageRef = storageRef.child("mods")
    private lazy var ammoImageRef = storageRef.child("ammo")
    private lazy var medsImageRef = storageRef.child("meds")
    private lazy var armorImageRef = storageRef.child("armor")
    private lazy var rigsImageRef = storageRef.child("rigs")
    private lazy var helmetImageRef = storageRef.child("armor")
    private lazy var visorImageRef = storageRef.child("armor")
    private lazy var tradersImageRef = storageRef.child("traders")
    private lazy var throwableImageRef = storageRef.child("throwables")
    private lazy var meleeImageRef = storageRef.child("melee")
    private lazy var characterImageRef = storageRef.child("character")
    var sessionDelegate: SessionDelegate
    var userMetadata: BBUser?
    lazy var nextAvailableReward: BudPointsReward = {
        let persistedTimestamp = prefsManager.valueForDoublePref(.nextRewardDate)
        let persistedRewardAmount = prefsManager.valueForIntPref(.nextRewardAmount)
        let nextRewardDate: Date
        let nextRewardPoints: Int

        if persistedTimestamp > 0 && persistedRewardAmount > 0 {
            nextRewardDate = Date(timeIntervalSince1970: persistedTimestamp)
            nextRewardPoints = persistedRewardAmount
        } else {
            nextRewardDate = Date()
            nextRewardPoints = randomPointValue()
        }

        return BudPointsReward(nextAvailableDate: nextRewardDate, pointValue: nextRewardPoints)
    }()
    private lazy var prefsManager = DependencyManagerImpl.shared.prefsManager()
    var globalMetadata: GlobalMetadata?

    private var cachedCharacters: [Character]?
    private var cachedFirearms: [Firearm]?
    private var cachedAmmo: [Ammo]?
    private var cachedArmor: [Armor]?
    private var cachedMedical: [Medical]?
    private var cachedThrowables: [Throwable]?
    private var cachedMelee: [MeleeWeapon]?

    init(sessionDelegate: SessionDelegate) {
        self.sessionDelegate = sessionDelegate

        super.init()

        FirebaseApp.configure()
        Messaging.messaging().delegate = self
    }

    func updateNextAvailableReward() {
        // Random delay between 15 minutes and 1 hour...
        let randomTimestampInFuture = Date().timeIntervalSince1970 + Double.random(in: 900.0...3_600.0)
        let newDate = Date(timeIntervalSince1970: randomTimestampInFuture)
        let newPointValue = randomPointValue()
        nextAvailableReward = BudPointsReward(nextAvailableDate: newDate, pointValue: newPointValue)

        prefsManager.update(.nextRewardDate, value: randomTimestampInFuture)
        prefsManager.update(.nextRewardAmount, value: newPointValue)
    }

    func randomPointValue() -> Int { return Int.random(in: 5...100) }

    // MARK:- Images
    func itemImageReference(itemId: String, itemType: ItemType, size: ImageSize) -> StorageReference {
        let imageId = itemId + size.rawValue
        switch itemType {
        case .firearm: return firearmsImageRef.child(imageId)
        case .modification: return modsImageRef.child(imageId)
        case .ammo: return ammoImageRef.child(imageId)
        case .medical: return medsImageRef.child(imageId)
        case .armor: return armorImageRef.child(imageId)
        case .rig: return rigImageRef.child(imageId)
        case .helmet: return helmetImageRef.child(imageId)
        case .visor: return visorImageRef.child(imageId)
        case .throwable: return throwableImageRef.child(imageId)
        case .melee: return meleeImageRef.child(imageId)
        }
    }

    func avatarImageReference(characterId: String) -> StorageReference {
        let imageId = characterId + ImageSize.avatar.rawValue
        return characterImageRef.child(imageId)
    }
}

// TODO: v1.2.0...
extension FirebaseManager: PushNotificationManager, UNUserNotificationCenterDelegate, MessagingDelegate {
    func enablePushNotifications(enabled: Bool) {
        UNUserNotificationCenter.current().delegate = self

		UNUserNotificationCenter.current().requestAuthorization( options: [.alert, .badge, .sound], completionHandler: {_, _ in })
        UIApplication.shared.registerForRemoteNotifications()
    }

    func pushNotificationsEnabled(handler: @escaping (_ : Bool) -> Void) {
        let current = UNUserNotificationCenter.current()

        current.getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .authorized: handler(true)
            default: handler(false)
            }
        })
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")

        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

// MARK:- Account Manager
extension FirebaseManager: AccountManager {
    func initializeSession() {
        print("Initializing anonymous session...")

        Auth.auth().signInAnonymously() { (authResult, error) in
            if let error = error {
                print("Anonymous auth failed with error: ", error)
            } else {
                print("Anonymous auth succeeded.")
            }

            self.updateAccountProperties([AccountProperty.lastLogin: Timestamp(date: Date())]) { _ in }
            self.updateGlobalMetadata(handler: { _ in self.sessionDelegate.sessionDidFinishLoading() })
        }
    }

    func isLoggedIn() -> Bool { return currentUser() != nil }
    func currentUser() -> User? { return Auth.auth().currentUser }

    func getValueForAccountProperty(_ property: AccountProperty, completion: @escaping (Any?) -> Void) {
        guard let currentUser = currentUser() else { return }

        db.collection("users").document(currentUser.uid).getDocument { (snapshot, err) in
            if let err = err {
                print("Error fecthing value for properties: \(err)")
                return
            }

            guard let value = snapshot?.data()?[property.rawValue] else {
                print("Account value not present in data: \(property)")
                completion(nil)
                return
            }

            completion(value)
        }
    }

    func updateAccountProperties(_ properties: [AccountProperty: Any], completion: @escaping (_: Bool) -> Void) {
        guard let currentUser = currentUser() else { return }

        var data: [String: Any] = [:]
        for property in properties.keys { data[property.rawValue] = properties[property] }
        db.collection("users").document(currentUser.uid).setData(data, merge: true) { err in
            if let err = err {
                print("Error updating account properties: \(err)")
                completion(false)
                return
            }

            print("Account properties successfully written!")
            print("Fetching updated user data...")
            self.refreshUserMetadata() { userMeta in
                guard let userMeta = userMeta else {
                    print("Error fetching updated user data: \(err.debugDescription)")
                    completion(true)
                    return
                }

                print("User data successfully refreshed!!")
                self.userMetadata = userMeta
                completion(true)
            }
        }
    }

    func addLoyaltyPoints(_ points: Int, completion: @escaping () -> Void) {
        print("Adding \(points) loyalty points to account!")

        updateAccountProperties([AccountProperty.loyalty: FieldValue.increment(Int64(points))]) { _ in completion() }
    }

    func refreshUserMetadata(_ handler: @escaping (_ : BBUser?) -> Void) {
        guard let currentUser = currentUser() else { return }
        let usersRef = db.collection(FirebaseCollection.users.rawValue).document(currentUser.uid)
        usersRef.getDocument() { (document, err) in
            guard let document = document, document.exists, var userMeta = document.data() else {
                handler(nil)
                return
            }

            userMeta["id"] = currentUser.uid
            self.userMetadata = BBUser(userMeta)
            handler(self.userMetadata)
        }
    }

    func nextAvailableBudPointsReward() -> BudPointsReward {
        return nextAvailableReward
    }

    func redeemBudPoints(completion: @escaping () -> Void) {
        addLoyaltyPoints(nextAvailableReward.points) {
            self.updateNextAvailableReward()
            completion()
        }
    }

    func currentUserMetadata() -> BBUser? { return userMetadata }
}

// MARK:- Global Metadata
extension FirebaseManager: GlobalMetadataManager {
    func getGlobalMetadata() -> GlobalMetadata? { return globalMetadata }

    func updateGlobalMetadata(handler: @escaping (_ : GlobalMetadata?) -> Void) {
        db.collection(FirebaseCollection.global.rawValue).getDocuments() { (querySnapshot, err) in
            guard err == nil else {
                print("ERROR fetching global metadata: " + err.debugDescription)
                handler(nil);
                return
            }

            guard let globalMeta = querySnapshot?.documents.first?.data() else {
                print("ERROR: Global meta did not include expected data!")
                handler(self.globalMetadata)
                return
            }

            self.globalMetadata = GlobalMetadata(json: globalMeta)
            handler(self.globalMetadata)
        }
    }
}

/*
 News Post

 Title
  12/2/12
 body
 */

// MARK:- Database
extension FirebaseManager: DatabaseManager {
//    func getAppNews(handler: @escaping (_: NewsPost?) -> Void) {
//        db.collection(FirebaseCollection.news.rawValue).order(by: "index").getDocuments() { (querySnapshot, err) in
//            if let error = err {
//                print("Failed to get all news w/ error: ", error.localizedDescription)
//                handler(nil)
//                return
//            }
//
//            guard let snapshot = querySnapshot else { handler(nil); return }
//            print("Successfully fetched \(String(snapshot.documents.count)) news.")
//        }
//
//        let post = NewsPost(json: json)
//        handler(post)
//    }

    // MARK:- Characters
    func getCharacters(handler: @escaping (_: [Character]) -> Void) {
        if let cache = cachedCharacters {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.character.rawValue).order(by: "index").getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all characters w/ error: ", error.localizedDescription)
                handler([]);
                return
            }

            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) characters.")
            let characters = snapshot.getCharacters()
            self.cachedCharacters = characters
            handler(characters)
        }
    }

    // MARK:- Item Search
    func getAllItemsWithSearchQuery(_ query: String, handler: @escaping (_: [BaseItem]) -> Void) {
        var allResults: [BaseItem] = []
        self.getFirearmsWithSearchQuery(query) { (firearms) in
            allResults += firearms
            self.getAllArmorWithSearchQuery(query) { armor in
                allResults += armor
                self.getAmmoWithSearchQuery(query) { ammo in
                    allResults += ammo
                    self.getMedicalWithSearchQuery(query) { medical in
                        allResults += medical
                        self.getThrowablesWithSearchQuery(query) { throwables in
                            allResults += throwables
                            self.getMeleeWithSearchQuery(query) { melee in
                                allResults += melee
                                handler(allResults)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK:- Search items
    func getFirearmsWithSearchQuery(_ query: String, handler: @escaping (_: [Firearm]) -> Void) {
        getAllFirearms { firearms in
            let filteredResults = firearms.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
                    || $0.caliber.containsIgnoringCase(query)
                    || $0.firearmType.rawValue.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getAllArmorWithSearchQuery(_ query: String, handler: @escaping (_: [Armor]) -> Void) {
        getAllArmor { armor in
            let filteredResults = armor.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
                    || $0.material.rawValue.containsIgnoringCase(query)
                    || $0.armorType.rawValue.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getBodyArmorWithSearchQuery(_ query: String, handler: @escaping (_: [Armor]) -> Void) {
        getAllBodyArmor { armor in
            let filteredResults = armor.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
                    || $0.material.rawValue.containsIgnoringCase(query)
                    || $0.armorType.rawValue.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getHelmetsWithSearchQuery(_ query: String, handler: @escaping (_: [Armor]) -> Void) {
        getAllHelmets { armor in
            let filteredResults = armor.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
                    || $0.material.rawValue.containsIgnoringCase(query)
                    || $0.armorType.rawValue.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getAmmoWithSearchQuery(_ query: String, handler: @escaping (_: [Ammo]) -> Void) {
        getAllAmmo { ammo in
            let filteredResults = ammo.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
                    || $0.caliber.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getMedicalWithSearchQuery(_ query: String, handler: @escaping (_: [Medical]) -> Void) {
        getAllMedical { medical in
            let filteredResults = medical.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getThrowablesWithSearchQuery(_ query: String, handler: @escaping (_: [Throwable]) -> Void) {
        getAllThrowables { throwables in
            let filteredResults = throwables.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    func getMeleeWithSearchQuery(_ query: String, handler: @escaping (_: [MeleeWeapon]) -> Void) {
        getAllMelee { melee in
            let filteredResults = melee.filter {
                $0.displayDescription.containsIgnoringCase(query)
                    || $0.displayName.containsIgnoringCase(query)
                    || $0.displayNameShort.containsIgnoringCase(query)
            }

            handler(filteredResults)
        }
    }

    // MARK:- All items
    func getAllFirearms(handler: @escaping (_: [Firearm]) -> Void) {
        if let cache = cachedFirearms {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.firearms.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all firearms w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) firearms.")
            let firearms = snapshot.getFirearms()
            self.cachedFirearms = firearms
            handler(firearms)
        }
    }

    func getAllArmor(handler: @escaping (_: [Armor]) -> Void) {
        if let cache = cachedArmor {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.armor.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all armor w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) armors.")
            let armor = snapshot.getArmor()
            self.cachedArmor = armor
            handler(armor)
        }
    }

    internal func getAllArmor(withTypes types: [ArmorType], handler: @escaping (_: [Armor]) -> Void) {
        getAllArmor { results in handler(results.filter { types.contains($0.armorType) }) }
    }

    func getAllBodyArmor(handler: @escaping (_: [Armor]) -> Void) {
        getAllArmor(withTypes: [.body], handler: handler)
    }

    func getAllHeadArmor(handler: @escaping (_: [Armor]) -> Void) {
        getAllArmor(withTypes: [.attachment, .visor, .helmet], handler: handler)
    }

    func getAllHelmets(handler: @escaping ([Armor]) -> Void) {
        getAllArmor(withTypes: [.helmet], handler: handler)
    }

    func getAllHelmetArmor(handler: @escaping (_: [Armor]) -> Void) {
        getAllArmor(withTypes: [.visor,. attachment], handler: handler)
    }

    func getAllAmmo(handler: @escaping (_: [Ammo]) -> Void) {
        if let cache = cachedAmmo {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.ammo.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all ammo w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) ammo.")
            let allAmmo = snapshot.getAmmo().sorted(by: { $0.penetration > $1.penetration })
            self.cachedAmmo = allAmmo
            handler(allAmmo)
        }
    }

    func getAllMedical(handler: @escaping (_: [Medical]) -> Void) {
        if let cache = cachedMedical {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.medical.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all medical w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) medical items.")
            let medical = snapshot.getMedical()
            self.cachedMedical = medical
            handler(medical)
        }
    }

    func getAllThrowables(handler: @escaping (_: [Throwable]) -> Void) {
        if let cache = cachedThrowables {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.throwables.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all throwables w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) throwables.")
            let throwables = snapshot.getThrowables()
            self.cachedThrowables = throwables
            handler(throwables)
        }
    }

    func getAllMelee(handler: @escaping (_: [MeleeWeapon]) -> Void) {
        if let cache = cachedMelee {
            handler(cache)
            return
        }

        db.collection(FirebaseCollection.melee.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all melee w/ error: ", error.localizedDescription)
                handler([]);
                return
            }

            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) melee weapons.")
            let melee = snapshot.getMelee()
            self.cachedMelee = melee
            handler(melee)
        }
    }

    // MARK:- Mapped by category
    func getAllFirearmsByType(handler: @escaping ([FirearmType: [Firearm]]) -> Void) {
        getAllFirearms { firearms in
            var map: [FirearmType: [Firearm]] = [:]
            for type in FirearmType.allCases { map[type] = [] }
            for firearm in firearms { map[firearm.firearmType]?.append(firearm) }
            handler(map)
        }
    }

    func getAllArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void) {
        getAllArmor { allArmor in
            var map: [ArmorClass: [Armor]] = [:]
            for type in ArmorClass.allCases { map[type] = [] }
            for armor in allArmor { map[armor.armorClass]?.append(armor) }
            handler(map)
        }
    }

    func getAllBodyArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void) {
        getAllBodyArmor { allArmor in
            var map: [ArmorClass: [Armor]] = [:]
            for type in ArmorClass.allCases { map[type] = [] }
            for armor in allArmor { map[armor.armorClass]?.append(armor) }
            handler(map)
        }
    }

    func getAllHelmetsByClass(handler: @escaping ([ArmorClass : [Armor]]) -> Void) {
        getAllHelmets { allArmor in
            var map: [ArmorClass: [Armor]] = [:]
            for type in ArmorClass.allCases { map[type] = [] }
            for armor in allArmor { map[armor.armorClass]?.append(armor) }
            handler(map)
        }
    }

    func getAllHelmetArmorByClass(handler: @escaping ([ArmorClass: [Armor]]) -> Void) {
        getAllHelmetArmor { allArmor in
            var map: [ArmorClass: [Armor]] = [:]
            for type in ArmorClass.allCases { map[type] = [] }
            for armor in allArmor { map[armor.armorClass]?.append(armor) }
            handler(map)
        }
    }

    func getAllAmmoByCaliber(handler: @escaping ([String: [Ammo]]) -> Void) {
        getAllAmmo { allAmmo in
            var map: [String: [Ammo]] = [:]
            for ammo in allAmmo {
                var ammoForCaliber = map[ammo.caliber] ?? []
                ammoForCaliber.append(ammo)
                map[ammo.caliber] = ammoForCaliber
            }
            handler(map)
        }
    }

    func getAllMedicalByType(handler: @escaping ([MedicalItemType: [Medical]]) -> Void) {
        getAllMedical { allMeds in
            var map: [MedicalItemType: [Medical]] = [:]
            for type in MedicalItemType.allCases { map[type] = [] }
            for medical in allMeds { map[medical.medicalItemType]?.append(medical) }
            handler(map)
        }
    }

    // MARK:- Subtype queries
    func getAllFirearmsOfType(type: FirearmType, handler: @escaping ([Firearm]) -> Void) {
        getAllFirearms { results in handler(results.filter { $0.firearmType == type } ) }
    }

    func getAllFirearmsOfCaliber(caliber: String, handler: @escaping ([Firearm]) -> Void) {
        getAllFirearms { results in handler(results.filter { $0.caliber == caliber } ) }
    }

    func getAllAmmoOfCaliber(caliber: String, handler: @escaping ([Ammo]) -> Void) {
        getAllAmmo { results in handler(results.filter { $0.caliber == caliber } ) }
    }

    func getAllBodyArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void) {
        getAllBodyArmor { results in handler(results.filter { $0.armorClass == armorClass } ) }
    }

    func getAllHelmetsOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void) {
        getAllHelmets { results in handler(results.filter { $0.armorClass == armorClass } ) }
    }

    func getAllHelmetArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void) {
        getAllHelmetArmor { results in handler(results.filter { $0.armorClass == armorClass } ) }
    }

    func getAllBodyArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        getAllBodyArmor { results in handler(results.filter { $0.material == material } ) }
    }

    func getAllHelmetsWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        getAllHelmets { results in handler(results.filter { $0.material == material } ) }
    }

    func getAllHelmetArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        getAllHelmetArmor { results in handler(results.filter { $0.material == material } ) }
    }
}

extension QuerySnapshot {
    func getCharacters() -> [Character] { return documents.compactMap{ Character(json: $0.data()) } }
    func getFirearms() -> [Firearm] { return documents.compactMap{ Firearm(json: $0.data()) } }
    func getArmor() -> [Armor] { return documents.compactMap{ Armor(json: $0.data()) } }
    func getAmmo() -> [Ammo] { return documents.compactMap{ Ammo(json: $0.data()) } }
    func getMedical() -> [Medical] { return documents.compactMap{ Medical(json: $0.data()) } }
    func getMelee() -> [MeleeWeapon] { return documents.compactMap{ MeleeWeapon(json: $0.data()) } }
    func getThrowables() -> [Throwable] { return documents.compactMap{ Throwable(json: $0.data()) } }
    func getMods() -> [Modification] { return documents.compactMap{ Modification(json: $0.data()) } }
}
