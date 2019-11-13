import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import {useAuthManager, useGlobalMetadataManager} from './FirebaseProvider';
import SplashScreen from 'react-native-splash-screen';

const AuthContext = createContext();

const AuthenticationProvider = ({
  children,
  initialState = {authenticated: false, user: null}
}) => {
  const [state, setState] = useState(initialState);
  const {updateGlobalMetadata} = useGlobalMetadataManager();
  const auth = useAuthManager();
  const isLoggedIn = auth.isLoggedIn();

  const initializeSession = async () => {
    await auth.initializeSession();
    await updateGlobalMetadata();
    setAuthenticated();
  };

  const setAuthenticated = () => {
    if (isLoggedIn) {
      setState({
        authenticated: true,
        user: auth.currentUser()
      });

      SplashScreen.hide();
    }
  };

  useEffect(() => {
    initializeSession();
  }, []);

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
