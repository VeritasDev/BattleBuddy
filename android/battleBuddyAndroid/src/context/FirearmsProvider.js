import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';

const FirearmsContext = createContext();

const FirearmsProvider = ({children}) => {
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

  const getFirearmsByClass = async () => {
    _setLoading();

    const data = await db.getAllFirearmsByType();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  const getAllFirearms = async () => {
    _setLoading();

    const data = await db.getAllFirearms();

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
