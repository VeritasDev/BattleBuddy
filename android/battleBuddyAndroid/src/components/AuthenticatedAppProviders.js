import React from 'react';
import PropTypes from 'prop-types';
import ItemProvider from '../context/ItemProvider';
import SearchProvider from '../context/SearchProvider';

const AuthenticatedAppProviders = ({children}) => {
  return (
    <ItemProvider>
      <SearchProvider>{children}</SearchProvider>
    </ItemProvider>
  );
};

AuthenticatedAppProviders.propTypes = {
  children: PropTypes.node.isRequired
};

export default AuthenticatedAppProviders;
