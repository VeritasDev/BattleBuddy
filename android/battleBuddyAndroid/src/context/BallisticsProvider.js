import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';

const BallisticsContext = createContext([{}, () => {}]);

const BallisticsProvider = ({children}) => {
  const [state, setState] = useState({
    selectedAmmo: null,
    selectedArmor: null
  });

  const setAmmo = (ammo) => {
    setState((prevState) => ({...prevState, selectedAmmo: ammo}));
  };

  const clearState = () => {
    setState({
      selectedAmmo: null,
      selectedArmor: null
    });
  };

  return (
    <BallisticsContext.Provider value={{...state, setAmmo, clearState}}>
      {children}
    </BallisticsContext.Provider>
  );
};

BallisticsProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useBallistics = () => useContext(BallisticsContext);

export default BallisticsProvider;
