import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';

const ItemContext = createContext();

const ItemProvider = ({children}) => {
  const [state, setState] = useState({
    loading: true,
    error: null,
    data: null,
    collectionName: null
  });

  const db = useDbManager();

  const setCollectionName = (name) => {
    setState((prevState) => ({
      ...prevState,
      collectionName: name
    }));
  };

  useEffect(() => {
    if (state.collectionName) {
      db.getAllFirearmsByType().then((x) => {
        console.log(x);
        setState((prevState) => ({...prevState, data: x, loading: false}));
      });
    }
  }, [state.collectionName]);

  return (
    <ItemContext.Provider value={{...state, setCollectionName}}>
      {children}
    </ItemContext.Provider>
  );
};

export const useItems = () => useContext(ItemContext);

ItemProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export default ItemProvider;
