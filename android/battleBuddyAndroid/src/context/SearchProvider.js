import React, {useState, useEffect, useContext, createContext} from 'react';
import PropTypes from 'prop-types';
import {useDbManager} from './FirebaseProvider';

const SearchContext = createContext();

const SearchProvider = ({children}) => {
  const db = useDbManager();
  const [state, setState] = useState({
    loading: false,
    data: null,
    error: null,
    searchTerm: ''
  });

  const setSearchTerm = (term) => {
    setState((prevState) => ({
      ...prevState,
      searchTerm: term
    }));
  };

  const _searchDb = async (query) => {
    setState((prevState) => ({
      ...prevState,
      loading: true
    }));

    const data = await db.getAllItemsWithSearchQuery(query);

    setState((prevState) => ({
      ...prevState,
      data,
      loading: false
    }));
  };

  useEffect(() => {
    if (state.searchTerm) {
      _searchDb(state.searchTerm);
    }
  }, [state.searchTerm]);

  return (
    <SearchContext.Provider value={{setSearchTerm, ...state}}>
      {children}
    </SearchContext.Provider>
  );
};

export const useSearch = () => useContext(SearchContext);

SearchProvider.propTypes = {
  children: PropTypes.node.isRequired
};

export default SearchProvider;
