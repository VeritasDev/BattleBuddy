import React, {useState, useContext, createContext} from 'react';
import PropTypes from 'prop-types';
import FirebaseManager, {
  AccountManager,
  DatabaseManager,
  GlobalMetadataManager
} from '../utils/FirebaseManager';

const FirebaseContext = createContext();

const FirebaseProvider = ({children}) => {
  const [providers] = useState({
    firebase: new FirebaseManager(),
    auth: new AccountManager(),
    db: new DatabaseManager(),
    globalMetadata: new GlobalMetadataManager()
  });

  return (
    <FirebaseContext.Provider value={providers}>
      {children}
    </FirebaseContext.Provider>
  );
};

const useFirebaseManager = () => useContext(FirebaseContext);

export const useFirebase = () => {
  const {firebase} = useFirebaseManager();

  return firebase;
};

export const useAuthManager = () => {
  const {auth} = useFirebaseManager();

  return auth;
};

export const useDbManager = () => {
  const {db} = useFirebaseManager();

  return db;
};

export const useGlobalMetadataManager = () => {
  const {globalMetadata} = useFirebaseManager();

  return globalMetadata;
};

FirebaseProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export default FirebaseProvider;
