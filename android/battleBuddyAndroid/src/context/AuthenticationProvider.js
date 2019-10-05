import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import useAuthStateChange from '../hooks/useAuthStateChange';

const AuthContext = createContext();

const AuthenticationProvider = ({
  children,
  initialState = {authenticated: false, user: null}
}) => {
  const [state, setState] = useState(initialState);
  const authState = useAuthStateChange();

  useEffect(() => {
    if (authState) {
      setState({
        authenticated: true,
        user: authState._user
      });
    }
  }, [authState]);

  return (
    <AuthContext.Provider value={{...state}}>{children}</AuthContext.Provider>
  );
};

export const useAuthentication = () => useContext(AuthContext);

AuthenticationProvider.propTypes = {
  children: PropTypes.node.isRequired,
  initialState: PropTypes.shape({
    user: PropTypes.any.isRequired,
    authenticated: PropTypes.bool.isRequired
  })
};

export default AuthenticationProvider;
