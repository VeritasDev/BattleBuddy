import firestore from '@react-native-firebase/firestore';
import storage from '@react-native-firebase/storage';
import auth from '@react-native-firebase/auth';
import ItemType from '../constants/ItemType';
import FirearmType from '../constants/FirearmType';

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

  constructor() {
    super();
    this.updateGlobalMetadata();
  }

  getGlobalMetadata() {
    return this.globalMetadata;
  }

  async updateGlobalMetadata(handler) {
    try {
      const snapshot = await this.db
        .collection('global')
        .doc('metadata')
        .get();

      this.globalMetadata = snapshot.data();
      if (handler) {
        handler(this.globalMetadata);
      }
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
      const gmManager = new GlobalMetadataManager();
      gmManager.updateGlobalMetadata();
      console.log('Anonymous auth succeeded.');
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
  getAllFirearms() {
    return this._getAllItemsByType(ItemType.firearm);
  }

  async getAllFirearmsByType() {
    const firearms = await this.getAllFirearms();
    const map = {};

    // eslint-disable-next-line no-unused-vars
    for (const [_, value] of Object.entries(FirearmType)) {
      map[value] = [];
    }

    firearms.forEach((x) => {
      map[x.class].push(x);
    });

    return map;
  }

  getAllMelee() {
    return this._getAllItemsByType(ItemType.melee);
  }

  getAllAmmo() {
    return this._getAllItemsByType(ItemType.ammo);
  }

  getAllArmor() {
    return this._getAllItemsByType(ItemType.armor);
  }

  getAllMedical() {
    return this._getAllItemsByType(ItemType.medical);
  }

  getAllThrowables() {
    return this._getAllItemsByType(ItemType.throwable);
  }

  async _getAllItemsByType(type) {
    try {
      const snapshot = await this.db
        .collection(type)
        .get()
        .then((x) => x.docs.map((d) => d.data()));

      console.log(
        `Successfully fetched ${snapshot.length} documents of type "${type}".`
      );
      return snapshot;
    } catch (error) {
      console.error(`Failed to get all items of type ${type} w/ error:`, error);
    }
  }
}

export default FirebaseManager;
