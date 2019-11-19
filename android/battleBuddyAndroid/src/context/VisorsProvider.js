import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';

const VisorsContext = createContext();

const VisorsProvider = ({children}) => {
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

  const getAllVisors = async () => {
    _setLoading();

    const data = await db.getAllVisors();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  const getAllVisorsByClass = async () => {
    _setLoading();

    const data = await db.getAllVisorsByClass();

    setState((prevState) => ({
      ...prevState,
      loading: false,
      data
    }));
  };

  return (
    <VisorsContext.Provider
      value={{...state, getAllVisorsByClass, getAllVisors}}
    >
      {children}
    </VisorsContext.Provider>
  );
};

VisorsProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useVisors = () => useContext(VisorsContext);

export default VisorsProvider;
