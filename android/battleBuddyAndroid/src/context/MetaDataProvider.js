import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import firestore from '@react-native-firebase/firestore';

const MetaDataContext = createContext();

const MetaDataProvider = ({children}) => {
  const [state, setState] = useState({
    loading: true,
    error: null,
    data: null
  });

  useEffect(() => {
    firestore()
      .collection('global')
      .doc('metadata')
      .get()
      .then((snapshot) => {
        setState((prevState) => ({
          ...prevState,
          loading: false,
          data: snapshot.data()
        }));
      })
      .catch((error) => {
        // TODO: error handling.
        setState((prevState) => ({...prevState, error}));
        console.error(error);
      });
  }, []);

  return (
    <MetaDataContext.Provider value={state}>
      {children}
    </MetaDataContext.Provider>
  );
};

export const useMetaData = () => useContext(MetaDataContext);

MetaDataProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export default MetaDataProvider;
