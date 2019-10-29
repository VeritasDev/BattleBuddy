import React, {useContext, useEffect, useState, createContext} from 'react';
import PropTypes from 'prop-types';
import ItemType from '../constants/ItemType';

const CacheContext = createContext([{}, () => {}]);

const CacheProvider = ({children}) => {
  const [state, setState] = useState({
    images: [],
    [ItemType.firearm]: {},
    [ItemType.ammo]: {}
  });

  useEffect(() => {
    return destroyCache;
  }, []);

  const destroyCache = () => {
    setState(null);
  };

  const updateCache = async (key, value) => {
    const isFunction = typeof value === 'function';

    if (isFunction) {
      setState((prevState) => {
        console.log('ISFUNCTION', key, prevState[key]);

        return {
          ...prevState,
          [key]: value(prevState[key])
        };
      });
    } else {
      setState((prevState) => ({...prevState, [key]: value}));
    }

    console.log(`Cache for type ${key} succesfully updated`);
  };

  return (
    <CacheContext.Provider value={{cache: state, destroyCache, updateCache}}>
      {children}
    </CacheContext.Provider>
  );
};

CacheProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useCache = () => useContext(CacheContext);

export default CacheProvider;
