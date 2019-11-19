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

  const clearData = () => {
    setState({
      loading: true,
      error: null,
      data: null,
      collectionName: null
    });
  };

  const setItemsState = (data, isMounted) => {
    if (isMounted) {
      setState((prevState) => ({
        ...prevState,
        loading: false,
        data
      }));
    }
  };

  useEffect(() => {
    let isMounted = true;

    if (state.collectionName) {
      switch (state.collectionName) {
        case 'firearm':
          db.getAllFirearmsByType().then((x) => setItemsState(x, isMounted));
          break;
        case 'armor':
          db.getAllArmorByClass().then((x) => setItemsState(x, isMounted));
          break;
        case 'helmet':
          db.getAllHelmetsByClass().then((x) => setItemsState(x, isMounted));
          break;
        case 'visor':
          db.getAllVisorsByClass().then((x) => setItemsState(x, isMounted));
          break;
        case 'tacticalrig':
          db.getAllChestRigsByClass().then((x) => setItemsState(x, isMounted));
          break;
        case 'ammunition':
          db.getAllAmmoByCaliber().then((x) => setItemsState(x, isMounted));
          break;
        case 'medical':
          db.getAllMedicalByType().then((x) => setItemsState(x, isMounted));
          break;
        case 'grenade':
          db.getAllThrowablesByType().then((x) => setItemsState(x, isMounted));
          break;
        case 'melee':
          db.getAllMelee().then((x) => setItemsState(x, isMounted));
          break;
      }
    }

    return () => {
      isMounted = false;
    };
  }, [state.collectionName]);

  return (
    <ItemContext.Provider value={{...state, setCollectionName, clearData}}>
      {children}
    </ItemContext.Provider>
  );
};

export const useItems = () => useContext(ItemContext);

ItemProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export default ItemProvider;
