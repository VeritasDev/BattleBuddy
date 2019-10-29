import {useFirebase} from '../context/FirebaseProvider';
import ImageType from '../constants/ImageType';

const fetchImage = async (item) => {
  const firebase = useFirebase();
  const ref = firebase.itemImageReference(
    item._id,
    item._kind,
    ImageType.medium
  );

  try {
    return ref.getDownloadURL();
  } catch (error) {
    return '../../assets/images/placeholders/ammo_placeholders/545_medium.png';
  }
};

const populateImages = async (collection) => {
  if (!Array.isArray(collection)) {
    const populatedObject = {};
    const entries = Object.entries(collection);

    await Promise.all(
      entries.map(async ([className, items]) => {
        if (items[0].image) {
          populatedObject[className] = items;
        } else {
          populatedObject[className] = await Promise.all(
            items.map(async (x) => ({
              ...x,
              image: await fetchImage(x)
            }))
          );
        }
      })
    );

    return populatedObject;
  }

  if (collection[0].image) {
    return collection;
  }

  return Promise.all(
    collection.map(async (x) => ({
      ...x,
      image: await fetchImage(x)
    }))
  );
};

export default populateImages;
