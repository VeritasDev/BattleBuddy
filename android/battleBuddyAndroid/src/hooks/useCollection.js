import {useState, useEffect} from 'react';
import {useDbManager} from '../context/FirebaseProvider';
import ItemType from '../constants/ItemType';
import ChestRig from '../models/ChestRig';

const useCollection = (collectionName) => {
  const db = useDbManager();
  const [state, setState] = useState({
    loading: true,
    data: null
  });

  const getCollection = async () => {
    const docs = await db.getAllItemsByCollection(collectionName);

    let normalized = docs;

    if (collectionName === ItemType.chestRig) {
      normalized = docs.map((x) => new ChestRig(x));
    }

    setState({loading: false, data: normalized});
  };

  useEffect(() => {
    getCollection();
  }, []);

  return state;
};

export default useCollection;
