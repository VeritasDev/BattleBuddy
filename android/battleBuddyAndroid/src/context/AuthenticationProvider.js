import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import {useAuthManager} from './FirebaseProvider';

const AuthContext = createContext();

const AuthenticationProvider = ({
  children,
  initialState = {authenticated: false, user: null}
}) => {
  const [state, setState] = useState(initialState);
  const auth = useAuthManager();
  const isLoggedIn = auth.isLoggedIn();

  useEffect(() => {
    auth.initializeSession();
  }, []);

  useEffect(() => {
    if (isLoggedIn) {
      setState({
        authenticated: true,
        user: auth.currentUser()
      });
    }
  }, [isLoggedIn]);

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
