import {useState, useEffect} from 'react';
import {useDbManager} from '../context/FirebaseProvider';

const useCollection = (collectionName) => {
  const db = useDbManager();
  const [state, setState] = useState({
    loading: true,
    data: null
  });

  const getCollection = async () => {
    const docs = await db.getAllItemsByCollection(collectionName);

    setState({loading: false, data: docs});
  };

  useEffect(() => {
    getCollection();
  }, []);

  return state;
};

export default useCollection;
