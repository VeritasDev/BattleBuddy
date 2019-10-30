import firestore from '@react-native-firebase/firestore';
import storage from '@react-native-firebase/storage';
import auth from '@react-native-firebase/auth';
import ItemType from '../constants/ItemType';
import FirearmType from '../constants/FirearmType';
import ArmorClass from '../constants/ArmorClass';
import getDescendantProp from './getDescendantProp';
import AmmoType from '../constants/AmmoType';
import MedicalItemType from '../constants/MedicalItemType';
import checkDocQueryMatch from './checkDocQueryMatch';
import ThrowableType from '../constants/ThrowableType';

const AccountProperty = {
  lastLogin: 'lastLogin',
  adsWatched: 'adsWatched'
};

class FirebaseManager {
  auth = auth();
  db = firestore();
  storage = storage();
  storageRef = this.storage.ref();
  firearmsImageRef = this.storageRef.child('guns');
  ammoImageRef = this.storageRef.child('ammo');
  medsImageRef = this.storageRef.child('meds');
  armorImageRef = this.storageRef.child('armor');
  tradersImageRef = this.storageRef.child('traders');
  throwableImageRef = this.storageRef.child('throwables');
  meleeImageRef = this.storageRef.child('melee');

  itemImageReference(itemId, itemType, size) {
    const imageId = itemId + size;

    switch (itemType) {
      case ItemType.firearm:
        return this.firearmsImageRef.child(imageId);
      case ItemType.melee:
        return this.meleeImageRef.child(imageId);
      case ItemType.ammo:
        return this.ammoImageRef.child(imageId);
      case ItemType.armor:
        return this.armorImageRef.child(imageId);
      case ItemType.medical:
        return this.medsImageRef.child(imageId);
      case ItemType.throwable:
        return this.throwableImageRef.child(imageId);
    }
  }
}

export class GlobalMetadataManager extends FirebaseManager {
  globalMetadata = null;

  getGlobalMetadata() {
    return this.globalMetadata;
  }

  async updateGlobalMetadata() {
    try {
      console.log('Fetching global metadata...');
      const snapshot = await this.db
        .collection('global')
        .doc('metadata')
        .get();

      this.globalMetadata = snapshot.data();
    } catch (error) {
      console.log('ERROR fetching global metadata: ', error.debugDescription);
    }
  }
}

export class AccountManager extends FirebaseManager {
  async initializeSession() {
    console.log('Initializing anonymous session...');

    try {
      await this.auth.signInAnonymously();
      this.updateAccountProperties({[AccountProperty.lastLogin]: Date.now()});
    } catch (error) {
      console.error('Anonymous auth failed with error: ', error);
    }
  }

  currentUser() {
    return this.auth.currentUser || null;
  }

  isLoggedIn() {
    return !!this.currentUser;
  }

  async getValueForAccountProperty(property, callback) {
    const currentUser = this.currentUser();

    if (!currentUser) return;

    try {
      const snapshot = await this.db
        .collection('users')
        .doc(currentUser.uid)
        .get();

      try {
        const value = snapshot.data();

        callback(value);
      } catch (error) {
        console.error(`Account value not present in data: ${property}`);
      }
    } catch (error) {
      // TODO: error handling
      console.log(`Error fecthing value for properties: ${error}`);
    }
  }

  async updateAccountProperties(properties) {
    const currentUser = this.currentUser();

    if (!currentUser) return;

    try {
      await this.db
        .collection('users')
        .doc(currentUser.uid)
        .set(properties, {merge: true});

      console.log('Account properties successfully written!');
    } catch (error) {
      console.error(`Error updating account properties: ${error}`);
    }
  }
}

export class DatabaseManager extends FirebaseManager {
  constructor() {
    super();
    this.db.settings({persistence: true});
  }

  /**
   * Private method to fetch all items by collection name.
   *
   * @param {string} collection - Collection name
   *
   * @returns {Promise}
   */
  async getAllItemsByCollection(collection) {
    try {
      const snapshot =
        collection === 'armor'
          ? await this.db
              .collection(collection)
              .where('type', '==', 'body')
              .get()
              .then((x) => x.docs.map((d) => d.data()))
          : await this.db
              .collection(collection)
              .get()
              .then((x) => x.docs.map((d) => d.data()));

      console.log(
        `Successfully fetched ${snapshot.length} documents of type "${collection}".`
      );
      return snapshot;
    } catch (error) {
      console.error(
        `Failed to get all items of type ${collection} w/ error:`,
        error
      );
    }
  }

  /**
   * Private method to fetch collection by certain type
   *
   * @param {string} collection - Name of collection
   * @param {string} property - Item property
   * @param {any} value - Item property value
   *
   * @returns {Promise}
   */
  async _getAllItemsOfType(collection, property, value) {
    try {
      const snapshot = await this.db
        .collection(collection)
        .where(property, value)
        .get()
        .then((x) => x.docs.map((d) => d.data()));
      // .then((d) => );

      console.log(
        `Successfully fetched ${snapshot.length} documents of type "${collection}".`
      );
      return snapshot;
    } catch (error) {
      console.error(
        `Failed to get all items of type ${collection} w/ error:`,
        error
      );
    }
  }

  /**
   * Private Method to fetch item and sort them by given property like "class"
   *
   * @param {string} collection - Name of collection
   * @param {*} type - Type like FirarmType or ArmorClass
   * @param {*} key - Item key like class, caliber, armor.class (supports dot notation)
   */
  async _getAllItemsByProperty(collection, type, key) {
    const docs = await this.getAllItemsByCollection(collection);
    // eslint-disable-next-line
    const map = Object.entries(type).map(([_, value]) => ({
      title: value,
      data: []
    }));

    switch (collection) {
      case ItemType.armor:
        docs.forEach((x) => {
          const title = `armor_class_${getDescendantProp(x, key)}`;
          const index = map.findIndex((t) => t.title === title);

          if (index === -1) {
            map.push({title, data: [x]});
          } else {
            map[index].data.push(x);
          }
        });
        break;
      case ItemType.ammo:
        docs.forEach((x) => {
          const title = x[key];
          const index = map.findIndex((t) => t.title === title);

          if (index === -1) {
            map.push({title, data: [x]});
          } else {
            map[index].data.push(x);
          }
        });
        break;
      default:
        docs.forEach((x) => {
          const title = getDescendantProp(x, key);
          const index = map.findIndex((t) => t.title === title);

          if (index === -1) {
            map.push({title, data: [x]});
          } else {
            map[index].data.push(x);
          }
        });
        break;
    }

    return map;
  }

  async getFirearmsWithSearchQuery(query) {
    const firearms = await this.getAllFirearms();

    return firearms.filter((x) => checkDocQueryMatch(x, 'firearm', query));
  }

  async getArmorWithSearchQuery(query) {
    const armor = await this.getAllArmor();

    return armor.filter((x) => checkDocQueryMatch(x, 'armor', query));
  }

  async getAmmoWithSearchQuery(query) {
    const ammo = await this.getAllAmmo();

    return ammo.filter((x) => checkDocQueryMatch(x, 'ammo', query));
  }

  async getMedicalWithSearchQuery(query) {
    const medical = await this.getAllMedical();

    return medical.filter((x) => checkDocQueryMatch(x, 'medical', query));
  }

  async getThrowablesWithSearchQuery(query) {
    const throwables = await this.getAllThrowables();

    return throwables.filter((x) => checkDocQueryMatch(x, 'grenade', query));
  }

  async getMeleeWithSearchQuery(query) {
    const melee = await this.getAllMelee();

    return melee.filter((x) => checkDocQueryMatch(x, 'melee', query));
  }

  async getAllItemsWithSearchQuery(query) {
    const firearms = await this.getFirearmsWithSearchQuery(query);
    const armor = await this.getArmorWithSearchQuery(query);
    const ammo = await this.getAmmoWithSearchQuery(query);
    const medical = await this.getMedicalWithSearchQuery(query);
    const throwables = await this.getThrowablesWithSearchQuery(query);
    const melee = await this.getMeleeWithSearchQuery(query);

    return [
      ...firearms,
      ...armor,
      ...ammo,
      ...medical,
      ...throwables,
      ...melee
    ];
  }

  // Get all items

  getAllFirearms() {
    return this.getAllItemsByCollection(ItemType.firearm);
  }

  getAllMelee() {
    return this.getAllItemsByCollection(ItemType.melee);
  }

  getAllAmmo() {
    return this.getAllItemsByCollection(ItemType.ammo);
  }

  async getAllArmor() {
    try {
      const snapshot = await this.db
        .collection('armor')
        .where('type', '==', 'body')
        .get()
        .then((x) => x.docs.map((d) => d.data()));

      console.log(
        `Successfully fetched ${
          snapshot.length
        } documents of type "${'armor'}".`
      );
      return snapshot;
    } catch (error) {
      console.error(
        `Failed to get all items of type ${'armor'} w/ error:`,
        error
      );
    }
  }

  getAllMedical() {
    return this.getAllItemsByCollection(ItemType.medical);
  }

  getAllThrowables() {
    return this.getAllItemsByCollection(ItemType.throwable);
  }

  // Get by type
  getAllFirearmsByType() {
    return this._getAllItemsByProperty(ItemType.firearm, FirearmType, 'class');
  }

  getAllArmorByClass() {
    return this._getAllItemsByProperty(
      ItemType.armor,
      ArmorClass,
      'armor.class'
    );
  }

  getAllBodyArmorByClass() {
    // No helmet implementation yet so we return above method.
    return this.getAllArmorByClass();
  }

  getAllAmmoByCaliber() {
    return this._getAllItemsByProperty(ItemType.ammo, AmmoType, 'caliber');
  }

  getAllMedicalByType() {
    return this._getAllItemsByProperty(
      ItemType.medical,
      MedicalItemType,
      'type'
    );
  }

  getAllThrowablesByType() {
    return this._getAllItemsByProperty(
      ItemType.throwable,
      ThrowableType,
      'type'
    );
  }

  // Get by category
  getAllFirearmsOfType(type) {
    return this._getAllItemsOfType(ItemType.firearm, 'class', type);
  }

  getAllFirearmsOfCaliber(caliber) {
    return this._getAllItemsOfType(ItemType.firearm, 'caliber', caliber);
  }

  getAllAmmoOfCaliber(caliber) {
    return this._getAllItemsOfType(ItemType.ammo, 'caliber', caliber);
  }

  getAllBodyArmorOfClass(armorClass) {
    return this._getAllItemsOfType(ItemType.armor, 'armor.class', armorClass);
  }

  getAllBodyArmorWithMaterial(material) {
    return this._getAllItemsOfType(
      ItemType.armor,
      'armor.material.name',
      material
    );
  }
}

export default FirebaseManager;
