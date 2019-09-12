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
import GoogleMobileAds
import FirebaseFirestore
import FirebaseAuth

enum FirebaseCollection: String {
    case firearms = "firearm"
    case armor = "armor"
    case ammo = "ammunition"
    case medical = "medical"
    case throwables = "grenade"
    case melee = "melee"
    case global = "global"
}

enum ImageSize: String {
    case medium = "_medium.jpg"
    case large = "_large.jpg"
    case full = "_full.jpg"
}

class FirebaseManager: NSObject {
    private lazy var db = Firestore.firestore()
    private lazy var storage = Storage.storage()
    private lazy var storageRef = storage.reference()
    private lazy var firearmsImageRef = storageRef.child("guns")
    private lazy var ammoImageRef = storageRef.child("ammo")
    private lazy var medsImageRef = storageRef.child("meds")
    private lazy var armorImageRef = storageRef.child("armor")
    private lazy var tradersImageRef = storageRef.child("traders")
    private lazy var throwableImageRef = storageRef.child("throwables")
    private lazy var meleeImageRef = storageRef.child("melee")
    var sessionDelegate: SessionDelegate

    let videoAd: GADRewardBasedVideoAd
    var adDelegate: AdDelegate?
    var currentVideoAdState: VideoAdState = .unavailable

    // TODO: Get real IDs
    private let videoAdUnit = "ca-app-pub-3940256099942544/1712485313"

    private lazy var prefsManager = DependencyManagerImpl.shared.prefsManager()
    var globalMetadata: GlobalMetadata?

    init(sessionDelegate: SessionDelegate) {
        self.sessionDelegate = sessionDelegate
        self.videoAd = GADRewardBasedVideoAd.sharedInstance()

        super.init()

        FirebaseApp.configure()

        // Uncomment this out for debugging purposes.
//        FirebaseConfiguration.shared.setLoggerLevel(.max)
        videoAd.delegate = self
        GADMobileAds.sharedInstance().start { _ in
            self.reloadVideoAd()
        }
    }

    // MARK:- Images

    func itemImageReference(itemId: String, itemType: ItemType, size: ImageSize) -> StorageReference {
        let imageId = itemId + size.rawValue
        switch itemType {
        case .firearm: return firearmsImageRef.child(imageId)
        case .ammo: return ammoImageRef.child(imageId)
        case .medical: return medsImageRef.child(imageId)
        case .armor: return armorImageRef.child(imageId)
        case .throwable: return throwableImageRef.child(imageId)
        case .melee: return meleeImageRef.child(imageId)
        }
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

            self.updateAccountProperties([AccountProperty.lastLogin: Timestamp(date: Date())])
            self.updateGlobalMetadata(handler: { _ in self.sessionDelegate.sessionDidFinishLoading() })
        }
    }

    func isLoggedIn() -> Bool {
        return currentUser() != nil
    }

    func currentUser() -> User? {
        return Auth.auth().currentUser
    }

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

    func updateAccountProperties(_ properties: [AccountProperty: Any]) {
        guard let currentUser = currentUser() else { return }

        var data: [String: Any] = [:]
        for property in properties.keys { data[property.rawValue] = properties[property] }
        db.collection("users").document(currentUser.uid).setData(data, merge: true) { err in
            if let err = err {
                print("Error updating account properties: \(err)")
            } else {
                print("Account properties successfully written!")
            }
        }
    }
}

// MARK:- Ads
extension FirebaseManager: AdManager {
    func bannerAdsEnabled() -> Bool { return prefsManager.valueForBoolPref(.bannerAds) }

    func updateBannerAdsSetting(_ enabled: Bool) { prefsManager.update(.bannerAds, value: enabled) }

    func reloadVideoAd(after delay: Double = 0) {
        updateAdState(state: .unavailable)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.currentVideoAdState = .loading
            self.videoAd.load(GADRequest(), withAdUnitID: self.videoAdUnit)
        }
    }

    func watchAdVideo(from rootVC: UIViewController) {
        if videoAd.isReady { videoAd.present(fromRootViewController: rootVC) }
    }

    func rewardForWatchingAd() {
        updateAccountProperties([.adsWatched: FieldValue.increment(Int64(1))])
    }
}

extension FirebaseManager: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        rewardForWatchingAd()
    }

    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        reloadVideoAd(after: 1)
    }

    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("AD FAILED!: \(error.localizedDescription)")
        updateAdState(state: .unavailable)
        reloadVideoAd(after: 15)
    }

    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        updateAdState(state: .ready)
    }

    func updateAdState(state: VideoAdState) {
        currentVideoAdState = state
        self.adDelegate?.adManager(self, didUpdate: currentVideoAdState)
    }
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

extension FirebaseManager: DatabaseManager {

    // MARK:- Item Search
    func getAllItemsWithSearchQuery(_ query: String, handler: @escaping (_: [BaseItem]) -> Void) {
        var allResults: [BaseItem] = []
        self.getFirearmsWithSearchQuery(query) { (firearms) in
            allResults += firearms
            self.getBodyArmorWithSearchQuery(query) { armor in
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
        db.collection(FirebaseCollection.firearms.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all firearms w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) firearms.")
            handler(snapshot.getFirearms())
        }
    }

    func getAllArmor(handler: @escaping (_: [Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all armor w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) armors.")
            handler(snapshot.getArmor())
        }
    }

    func getAllBodyArmor(handler: @escaping (_: [Armor]) -> Void) {
        let bodyArmorRef = db.collection(FirebaseCollection.armor.rawValue).whereField("type", isEqualTo: "body")
        bodyArmorRef.getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all body armor w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) body armors.")
            handler(snapshot.getArmor())
        }
    }

    func getAllAmmo(handler: @escaping (_: [Ammo]) -> Void) {
        db.collection(FirebaseCollection.ammo.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all ammo w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) ammo.")
            let allAmmo = snapshot.getAmmo().sorted(by: { $0.penetration > $1.penetration })
            handler(allAmmo)
        }
    }

    func getAllMedical(handler: @escaping (_: [Medical]) -> Void) {
        db.collection(FirebaseCollection.medical.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all medical w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) medical items.")
            handler(snapshot.getMedical())
        }
    }

    func getAllThrowables(handler: @escaping (_: [Throwable]) -> Void) {
        db.collection(FirebaseCollection.throwables.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all throwables w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) throwables.")
            handler(snapshot.getThrowables())
        }
    }

    func getAllMelee(handler: @escaping (_: [MeleeWeapon]) -> Void) {
        db.collection(FirebaseCollection.melee.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all melee w/ error: ", error.localizedDescription)
                handler([]);
                return
            }

            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) melee weapons.")
            handler(snapshot.getMelee())
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

    // MARK:- By category
    func getAllFirearmsOfType(type: FirearmType, handler: @escaping ([Firearm]) -> Void) {
        db.collection(FirebaseCollection.firearms.rawValue).whereField("class", isEqualTo: type.rawValue).getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            handler(querySnapshot?.getFirearms() ?? [])
        }
    }

    func getAllFirearmsOfCaliber(caliber: String, handler: @escaping ([Firearm]) -> Void) {
        db.collection(FirebaseCollection.firearms.rawValue).whereField("caliber", isEqualTo: caliber).getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            handler(querySnapshot?.getFirearms() ?? [])
        }
    }

    func getAllAmmoOfCaliber(caliber: String, handler: @escaping ([Ammo]) -> Void) {
        db.collection(FirebaseCollection.ammo.rawValue).whereField("caliber", isEqualTo: caliber).getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            handler(querySnapshot?.getAmmo() ?? [])
        }
    }

    func getAllBodyArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.class", isEqualTo: armorClass.rawValue).whereField("type", isEqualTo: "body").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            handler(snapshot.getArmor())
        }
    }

    func getAllBodyArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.material.name", isEqualTo: material.rawValue).whereField("type", isEqualTo: "body").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            handler(snapshot.getArmor())
        }
    }
}

extension QuerySnapshot {
    func getFirearms() -> [Firearm] { return documents.compactMap{ Firearm(json: $0.data()) } }
    func getArmor() -> [Armor] { return documents.compactMap{ Armor(json: $0.data()) } }
    func getAmmo() -> [Ammo] { return documents.compactMap{ Ammo(json: $0.data()) } }
    func getMedical() -> [Medical] { return documents.compactMap{ Medical(json: $0.data()) } }
    func getMelee() -> [MeleeWeapon] { return documents.compactMap{ MeleeWeapon(json: $0.data()) } }
    func getThrowables() -> [Throwable] { return documents.compactMap{ Throwable(json: $0.data()) } }
}
