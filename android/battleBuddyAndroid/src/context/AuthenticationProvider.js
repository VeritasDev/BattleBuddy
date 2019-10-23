import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import {useAuthManager, useGlobalMetadataManager} from './FirebaseProvider';

const AuthContext = createContext();

const AuthenticationProvider = ({
  children,
  initialState = {authenticated: false, user: null}
}) => {
  const [state, setState] = useState(initialState);
  const auth = useAuthManager();
  const metadata = useGlobalMetadataManager();
  const isLoggedIn = auth.isLoggedIn();

  const initializeSession = async () => {
    await auth.initializeSession();
    await metadata.updateGlobalMetadata();
  };

  useEffect(() => {
    initializeSession();
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
