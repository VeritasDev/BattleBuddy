import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';

const ChestRigContext = createContext();

const ChestRigProvider = ({children}) => {
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

  const getAllChestRigs = async () => {
    _setLoading();

    const data = await db.getAllChestRigs();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  const getChestRigsByClass = async () => {
    _setLoading();

    const data = await db.getAllChestRigsByClass();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  return (
    <ChestRigContext.Provider
      value={{...state, getChestRigsByClass, getAllChestRigs}}
    >
      {children}
    </ChestRigContext.Provider>
  );
};

ChestRigProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useChestRigs = () => useContext(ChestRigContext);

export default ChestRigProvider;
