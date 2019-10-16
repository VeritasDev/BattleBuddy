import {useState, useEffect} from 'react';
import {useFirebase} from '../context/FirebaseProvider';

const placeholderImages = {
  firearm: {
    assaultRifle: require('../../assets/images/placeholders/weapon_placeholders/placeholder_ar.png'),
    assaultCarbine: require('../../assets/images/placeholders/weapon_placeholders/placeholder_carbine.png'),
    marksmanRifle: require('../../assets/images/placeholders/weapon_placeholders/placeholder_dmr.png'),
    machinegun: require('../../assets/images/placeholders/weapon_placeholders/placeholder_machinegun.png'),
    pistol: require('../../assets/images/placeholders/weapon_placeholders/placeholder_pistol.png'),
    shotgun: require('../../assets/images/placeholders/weapon_placeholders/placeholder_shotty.png'),
    smg: require('../../assets/images/placeholders/weapon_placeholders/placeholder_smg.png'),
    sniperRifle: require('../../assets/images/placeholders/weapon_placeholders/placeholder_sniper.png')
  },
  ammunition: {
    '5.45x39mm': require('../../assets/images/placeholders/ammo_placeholders/545_medium.png'),
    '5.56x45 NATO': require('../../assets/images/placeholders/ammo_placeholders/556_medium.png'),
    '7.62x39mm': require('../../assets/images/placeholders/ammo_placeholders/76239_medium.png'),
    '9x39mm': require('../../assets/images/placeholders/ammo_placeholders/939_medium.png'),
    '9x19 Parabellum': require('../../assets/images/placeholders/ammo_placeholders/919_medium.png'),
    '7.62x51mm NATO': require('../../assets/images/placeholders/ammo_placeholders/76251_medium.png'),
    'HK 4.6x30mm': require('../../assets/images/placeholders/ammo_placeholders/46_medium.png'),
    '7.62x54mmR': require('../../assets/images/placeholders/ammo_placeholders/76254_medium.png'),
    '12ga': require('../../assets/images/placeholders/ammo_placeholders/1270_medium.png'),
    '20ga': require('../../assets/images/placeholders/ammo_placeholders/2070_medium.png'),
    '.366 TKM': require('../../assets/images/placeholders/ammo_placeholders/366_medium.png'),
    '9x18mm Makarov': require('../../assets/images/placeholders/ammo_placeholders/918_medium.png'),
    '9x21mm Gyurza': require('../../assets/images/placeholders/ammo_placeholders/921_medium.png'),
    '7.62x25mm Tokarev': require('../../assets/images/placeholders/ammo_placeholders/76225_medium.png')
  },
  armor: {
    '1': require('../../assets/images/placeholders/armor_placeholders/class_2.png'),
    '2': require('../../assets/images/placeholders/armor_placeholders/class_2.png'),
    '3': require('../../assets/images/placeholders/armor_placeholders/class_3.png'),
    '4': require('../../assets/images/placeholders/armor_placeholders/class_4.png'),
    '5': require('../../assets/images/placeholders/armor_placeholders/class_5.png'),
    '6': require('../../assets/images/placeholders/armor_placeholders/class_6.png')
  },
  medical: {
    medkit: require('../../assets/images/placeholders/medical_placeholders/medkit_placeholder.png'),
    drug: require('../../assets/images/placeholders/medical_placeholders/painkiller_placeholder.png'),
    accessory: require('../../assets/images/placeholders/medical_placeholders/medical_placeholder.png'),
    stimulator: require('../../assets/images/placeholders/medical_placeholders/stim_placeholder.png')
  }
};

const useStorageImage = (doc, size) => {
  let placeholder;

  // TODO: Fuck this system.
  switch (doc._kind) {
    case 'firearm':
      placeholder = placeholderImages[doc._kind][doc.class];
      break;
    case 'armor':
      // TODO: Fix armor placeholder as sometimes it returns undefined.
      placeholder = placeholderImages.armor[1];
      // placeholder = placeholderImages[doc._kind][doc.armor]['class'];
      break;
    case 'ammunition':
      placeholder = placeholderImages[doc._kind][doc.caliber];
      break;
    case 'medical':
      placeholder = placeholderImages[doc._kind][doc.type];
      break;
    case 'grenade':
      placeholder = require('../../assets/images/placeholders/throwable_placeholders/placeholder_throwable.png');
      break;
    case 'melee':
      placeholder = require('../../assets/images/placeholders/melee_placeholders/placeholder_melee.png');
      break;
  }

  const firebase = useFirebase();
  const [state, setState] = useState({
    loading: true,
    image: null,
    placeholder
  });

  const loadImageFromRef = async () => {
    try {
      const uri = await firebase
        .itemImageReference(doc._id, doc._kind, size)
        .getDownloadURL();

      setState((prevState) => ({
        ...prevState,
        image: {uri}
      }));
    } catch (error) {
      console.log('somthing went wrong', doc._id);
    }
  };

  useEffect(() => {
    loadImageFromRef();
  }, []);

  return state;
};

export default useStorageImage;
