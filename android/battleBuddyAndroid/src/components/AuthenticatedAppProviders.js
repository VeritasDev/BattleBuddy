import React from 'react';
import PropTypes from 'prop-types';
import ItemProvider from '../context/ItemProvider';
import SearchProvider from '../context/SearchProvider';
import CacheProvider from '../context/CacheProvider';

const AuthenticatedAppProviders = ({children}) => {
  return (
    <CacheProvider>
      <ItemProvider>
        <SearchProvider>{children}</SearchProvider>
      </ItemProvider>
    </CacheProvider>
  );
};

AuthenticatedAppProviders.propTypes = {
  children: PropTypes.node.isRequired
};

export default AuthenticatedAppProviders;
