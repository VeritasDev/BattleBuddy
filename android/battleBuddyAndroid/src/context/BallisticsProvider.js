import React, {useContext, useState, createContext} from 'react';
import PropTypes from 'prop-types';

const BallisticsContext = createContext([{}, () => {}]);

const BallisticsProvider = ({children}) => {
  const [state, setState] = useState({
    armor: null,
    ammo: null
  });

  const setAmmo = (ammo) => {
    setState((prevState) => ({...prevState, ammo}));
  };

  const setArmor = (armor) => {
    setState((prevState) => ({...prevState, armor}));
  };

  const clearState = () => {
    setState({
      armor: null,
      ammo: null
    });
  };

  return (
    <BallisticsContext.Provider
      value={{...state, setAmmo, setArmor, clearState}}
    >
      {children}
    </BallisticsContext.Provider>
  );
};

BallisticsProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export const useBallistics = () => useContext(BallisticsContext);

export default BallisticsProvider;
