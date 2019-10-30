import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager, useGlobalMetadataManager} from './FirebaseProvider';

const AmmunitionContext = createContext();

const AmmunitionProvider = ({children}) => {
  const db = useDbManager();
  const {globalMetadata} = useGlobalMetadataManager();
  const [state, setState] = useState({
    data: null,
    loading: true,
    error: null
  });

  const _setLoading = () => {
    setState((prevState) => ({
      ...prevState,
      loading: true
    }));
  };

  const getAllAmmo = async () => {
    _setLoading();

    const data = await db.getAllAmmo();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  // TODO: reimplement sorting AMMO with new data structure
  // eslint-disable-next-line
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

    const data = await db.getAllAmmoByCaliber();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
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
