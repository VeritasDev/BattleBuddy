import React, {useState, useContext, createContext, useEffect} from 'react';
import PropTypes from 'prop-types';
import firestore from '@react-native-firebase/firestore';

const ItemContext = createContext();

const ItemProvider = ({children, collectionName}) => {
  const [state, setState] = useState({
    loading: true,
    error: null,
    data: null,
    collectionName
  });

  const setCollectionName = (name) => {
    setState((prevState) => ({
      ...prevState,
      collectionName: name
    }));
  };

  useEffect(() => {
    firestore()
      .collection(state.collectionName)
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
  }, [state.collectionName]);

  return (
    <ItemContext.Provider value={{...state, setCollectionName}}>
      {children}
    </ItemContext.Provider>
  );
};

export const useItems = () => useContext(ItemContext);

ItemProvider.propTypes = {
  children: PropTypes.node.isRequired,
  collectionName: PropTypes.string.isRequired
};

export default ItemProvider;
