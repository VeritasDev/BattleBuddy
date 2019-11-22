import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';

const HelmetsContext = createContext();

const HelmetsProvider = ({children}) => {
  const db = useDbManager();
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

  const getAllHelmets = async () => {
    _setLoading();

    const data = await db.getAllHelmets();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  const getAllHelmetsByClass = async () => {
    _setLoading();

    const data = await db.getAllHelmetsByClass();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  return (
    <HelmetsContext.Provider
      value={{...state, getAllHelmetsByClass, getAllHelmets}}
    >
      {children}
    </HelmetsContext.Provider>
  );
};

HelmetsProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useHelmets = () => useContext(HelmetsContext);

export default HelmetsProvider;
