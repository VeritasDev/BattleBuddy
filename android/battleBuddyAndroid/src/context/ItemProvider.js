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

  useEffect(() => {
    if (state.collectionName) {
      switch (state.collectionName) {
        case 'firearm':
          db.getAllFirearmsByType().then((x) => {
            setState((prevState) => ({...prevState, data: x, loading: false}));
          });
          break;
        case 'armor':
          db.getAllArmorByClass().then((x) => {
            setState((prevState) => ({...prevState, data: x, loading: false}));
          });
          break;
        case 'ammunition':
          db.getAllAmmoByCaliber().then((x) => {
            setState((prevState) => ({...prevState, data: x, loading: false}));
          });
          break;
        case 'medical':
          db.getAllMedicalByType().then((x) => {
            setState((prevState) => ({...prevState, data: x, loading: false}));
          });
          break;
        case 'grenade':
          db.getAllThrowablesByType().then((x) => {
            setState((prevState) => ({...prevState, data: x, loading: false}));
          });
          break;
        case 'melee':
          db.getAllMelee().then((x) => {
            setState((prevState) => ({...prevState, data: x, loading: false}));
          });
          break;
      }
    }
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
