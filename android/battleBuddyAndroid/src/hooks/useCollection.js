import {useState, useEffect} from 'react';
import firestore from '@react-native-firebase/firestore';

const useCollection = (collectionName) => {
  const [state, setState] = useState();

  const getCollection = async () => {
    const snapshot = await firestore()
      .collection(collectionName)
      .get();

    if (snapshot) {
      setState(snapshot._docs.map((x) => x._data));
    }
  };

  useEffect(() => {
    getCollection();
  }, []);

  return state;
};

export default useCollection;
