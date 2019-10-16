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
    private lazy var helmetImageRef = storageRef.child("armor")
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

    init(sessionDelegate: SessionDelegate) {
        self.sessionDelegate = sessionDelegate

        super.init()

        FirebaseApp.configure()

        // Uncomment this out for debugging purposes.
//        FirebaseConfiguration.shared.setLoggerLevel(.max)
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

    func randomPointValue() -> Int {
        return Int.random(in: 5...100)
    }

    // MARK:- Images
    func itemImageReference(itemId: String, itemType: ItemType, size: ImageSize) -> StorageReference {
        let imageId = itemId + size.rawValue
        switch itemType {
        case .firearm: return firearmsImageRef.child(imageId)
        case .modification: return modsImageRef.child(imageId)
        case .ammo: return ammoImageRef.child(imageId)
        case .medical: return medsImageRef.child(imageId)
        case .armor: return armorImageRef.child(imageId)
        case .helmet: return helmetImageRef.child(imageId)
        case .throwable: return throwableImageRef.child(imageId)
        case .melee: return meleeImageRef.child(imageId)
        }
    }

    func avatarImageReference(characterId: String) -> StorageReference {
        let imageId = characterId + ImageSize.avatar.rawValue
        return characterImageRef.child(imageId)
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

    func currentUserMetadata() -> BBUser? {
        return userMetadata
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

    // MARK:- Characters
    func getCharacters(handler: @escaping (_: [Character]) -> Void) {
        db.collection(FirebaseCollection.character.rawValue).order(by: "index").getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all characters w/ error: ", error.localizedDescription)
                handler([]);
                return
            }

            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) characters.")
            handler(snapshot.getCharacters())
        }
    }

    // MARK:- Item Search
    func getAllItemsWithSearchQuery(_ query: String, handler: @escaping (_: [BaseItem]) -> Void) {
        var allResults: [BaseItem] = []
        self.getFirearmsWithSearchQuery(query) { (firearms) in
            allResults += firearms
            self.getBodyArmorWithSearchQuery(query) { armor in
                allResults += armor
                self.getHelmetsWithSearchQuery(query) { armor in
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

    func getAllHelmets(handler: @escaping ([Armor]) -> Void) {
        let helmetRef = db.collection(FirebaseCollection.armor.rawValue).whereField("type", isEqualTo: "helmet")
        helmetRef.getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all helmets w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) helmets.")
            handler(snapshot.getArmor())
        }
    }

    func getAllHelmetArmor(handler: @escaping (_: [Armor]) -> Void) {
        let visorRef = db.collection(FirebaseCollection.armor.rawValue).whereField("type", isEqualTo: "visor")
        let attachmentRef = db.collection(FirebaseCollection.armor.rawValue).whereField("type", isEqualTo: "attachment")
        visorRef.getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all visors w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            let visors = snapshot.getArmor()

            attachmentRef.getDocuments() { (querySnapshot, err) in
                if let error = err {
                    print("Failed to get all helmet attachments w/ error: ", error.localizedDescription)
                    handler([]);
                    return
                }
                guard let snapshot = querySnapshot else { handler([]); return }

                let attachments = snapshot.getArmor()
                let combinedResults = visors + attachments
                print("Successfully fetched \(String(combinedResults.count)) helmet armor.")
                handler(combinedResults)
            }
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

    func getAllHelmetsOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.class", isEqualTo: armorClass.rawValue).whereField("type", isEqualTo: "helmet").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            handler(snapshot.getArmor())
        }
    }

    func getAllHelmetArmorOfClass(armorClass: ArmorClass, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.class", isEqualTo: armorClass.rawValue).whereField("type", isEqualTo: "visor").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            let visors = snapshot.getArmor()

            self.db.collection(FirebaseCollection.armor.rawValue).whereField("armor.class", isEqualTo: armorClass.rawValue).whereField("type", isEqualTo: "attachment").getDocuments() { (querySnapshot, err) in
                if err != nil { handler([]); return }
                guard let snapshot = querySnapshot else { handler([]); return }

                let attachments = snapshot.getArmor()
                handler(visors + attachments)
            }
        }
    }

    func getAllBodyArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.material.name", isEqualTo: material.rawValue).whereField("type", isEqualTo: "body").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            handler(snapshot.getArmor())
        }
    }

    func getAllHelmetsWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.material.name", isEqualTo: material.rawValue).whereField("type", isEqualTo: "helmet").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            handler(snapshot.getArmor())
        }
    }

    func getAllHelmetArmorWithMaterial(material: ArmorMaterial, handler: @escaping ([Armor]) -> Void) {
        db.collection(FirebaseCollection.armor.rawValue).whereField("armor.material.name", isEqualTo: material.rawValue).whereField("type", isEqualTo: "visor").getDocuments() { (querySnapshot, err) in
            if err != nil { handler([]); return }
            guard let snapshot = querySnapshot else { handler([]); return }
            let visors = snapshot.getArmor()

            self.db.collection(FirebaseCollection.armor.rawValue).whereField("armor.material.name", isEqualTo: material.rawValue).whereField("type", isEqualTo: "attachment").getDocuments() { (querySnapshot, err) in
                if err != nil { handler([]); return }
                guard let snapshot = querySnapshot else { handler([]); return }

                let attachments = snapshot.getArmor()
                handler(visors + attachments)
            }
        }
    }

    // MARK:- Mods
    func getAllMods(handler: @escaping (_: [Modification]) -> Void) {
        db.collection(FirebaseCollection.mods.rawValue).getDocuments() { (querySnapshot, err) in
            if let error = err {
                print("Failed to get all mods w/ error: ", error.localizedDescription)
                handler([]);
                return
            }
            guard let snapshot = querySnapshot else { handler([]); return }
            print("Successfully fetched \(String(snapshot.documents.count)) mods.")
            let allMods = snapshot.getMods().sorted(by: { $0.ergonomics > $1.ergonomics })
            handler(allMods)
        }
    }

    func getAllModsByType(handler: @escaping ([ModType: [Modification]]) -> Void) {
        getAllMods { mods in
            var map: [ModType: [Modification]] = [:]
            for type in ModType.allCases { map[type] = [] }
            for mod in mods { map[mod.modType]?.append(mod) }
            handler(map)
        }
    }

    func getAllModsOfType(_ type: ModType, handler: @escaping ([Modification]) -> Void) {

    }

    func getCompatibleItemsForFirearm(_ firearm: Firearm, handler: @escaping (FirearmBuildConfig) -> Void) {
        db.collection(FirebaseCollection.compatibility.rawValue).document(firearm.id).getDocument { (document, error) in
            if let document = document, document.exists {
                guard let data = document.data(), let ids = data["items"] as? [String] else { return }
                let config = FirearmBuildConfig(firearm: firearm, allCompatibleModIds:ids)
                handler(config)
            } else {

            }
        }
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
