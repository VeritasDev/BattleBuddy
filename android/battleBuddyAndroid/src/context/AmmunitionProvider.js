import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';
import useAmmoMetadata from '../hooks/useAmmoMetadata';

const AmmunitionContext = createContext();

const AmmunitionProvider = ({children}) => {
  const db = useDbManager();
  const ammoMetadata = useAmmoMetadata();
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

  const getAmmoByCaliber = async () => {
    _setLoading();
    const data = await db.getAllAmmoByCaliber();
    const sorted = [];

    if (ammoMetadata) {
      ammoMetadata.map((x) =>
        sorted.push(data.find((d) => d.title === x.name))
      );
    }

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data: sorted || data
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
