import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager, useGlobalMetadataManager} from './FirebaseProvider';
import {useCache} from './CacheProvider';
import ItemType from '../constants/ItemType';

const AmmunitionContext = createContext();

const AmmunitionProvider = ({children}) => {
  const db = useDbManager();
  const {globalMetadata} = useGlobalMetadataManager();
  const {cache, updateCache} = useCache();
  const [state, setState] = useState({
    data: null,
    loading: true,
    error: null
  });

  const ammoCache = cache[ItemType.ammo];

  const _setLoading = () => {
    setState((prevState) => ({
      ...prevState,
      loading: true
    }));
  };

  const _updateCache = (key, value) => {
    updateCache(ItemType.ammo, {[key]: value});
  };

  const getAllAmmo = async () => {
    _setLoading();
    let data;
    if (ammoCache && ammoCache.all) {
      data = ammoCache.all;
    } else {
      data = await db.getAllAmmo();
      _updateCache('all', data);
    }

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  const sortAmmoByMetadata = (data) => {
    const {ammoMetadata} = globalMetadata;
    const sortedAmmoMetadata = [];

    Object.entries(ammoMetadata).map(([key, {index}]) => {
      sortedAmmoMetadata[index] = key;
    });

    const sortedData = {};

    sortedAmmoMetadata.map((x) => {
      sortedData[x] = data[x];
    });

    return sortedData;
  };

  const getAmmoByCaliber = async () => {
    _setLoading();
    let data;
    if (ammoCache && ammoCache.byCaliber) {
      data = ammoCache.byCaliber;
    } else {
      data = await db.getAllAmmoByCaliber();
      _updateCache('byCaliber', data);
    }

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data: sortAmmoByMetadata(data)
    }));
  };

  return (
    <AmmunitionContext.Provider
      value={{...state, getAmmoByCaliber, getAllAmmo}}
    >
      {children}
    </AmmunitionContext.Provider>
  );
};

AmmunitionProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useAmmunition = () => useContext(AmmunitionContext);

export default AmmunitionProvider;
