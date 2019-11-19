import {useState, useEffect} from 'react';
import {useDbManager} from '../context/FirebaseProvider';
import ItemType from '../constants/ItemType';
import ChestRig from '../models/ChestRig';
import Armor from '../models/Armor';

const useCollection = (collectionName) => {
  const db = useDbManager();
  const [state, setState] = useState({
    loading: true,
    data: null
  });

  const getCollection = async () => {
    const docs = await db.getAllItemsByCollection(collectionName);

    let normalized;
    switch (collectionName) {
      case ItemType.chestRig:
        normalized = docs.map((x) => new ChestRig(x));
        break;
      case ItemType.armor:
      case ItemType.helmet:
        normalized = docs.map((x) => new Armor(x));
        break;
      default:
        normalized = docs;
        break;
    }

    setState({loading: false, data: normalized});
  };

  useEffect(() => {
    getCollection();
  }, []);

  return state;
};

export default useCollection;
