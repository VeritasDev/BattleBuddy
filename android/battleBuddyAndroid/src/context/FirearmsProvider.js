import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';
import {useCache} from './CacheProvider';
import ItemType from '../constants/ItemType';

const FirearmsContext = createContext();

const FirearmsProvider = ({children}) => {
  const db = useDbManager();
  const {cache, updateCache} = useCache();
  const [state, setState] = useState({
    data: null,
    loading: true,
    error: null
  });

  const fireArmCache = cache[ItemType.firearm];

  const _setLoading = () => {
    setState((prevState) => ({
      ...prevState,
      loading: true
    }));
  };

  const _updateCache = (key, value) => {
    updateCache(ItemType.firearm, {[key]: value});
  };

  const getFirearmsByClass = async () => {
    _setLoading();
    let data = null;

    if (fireArmCache && fireArmCache.byClass) {
      data = fireArmCache.byClass;
      _updateCache('byClass', data);
    } else {
      data = await db.getAllFirearmsByType();
    }

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  const getAllFirearms = async () => {
    _setLoading();
    let data = null;

    if (fireArmCache && fireArmCache.all) {
      data = fireArmCache.all;
    } else {
      data = await db.getAllFirearms();
      _updateCache('all', data);
    }

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  return (
    <FirearmsContext.Provider
      value={{...state, getAllFirearms, getFirearmsByClass}}
    >
      {children}
    </FirearmsContext.Provider>
  );
};

FirearmsProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useFirearms = () => useContext(FirearmsContext);

export default FirearmsProvider;
