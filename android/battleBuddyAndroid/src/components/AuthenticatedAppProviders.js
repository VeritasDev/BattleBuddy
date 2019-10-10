import React from 'react';
import PropTypes from 'prop-types';
import MetaDataProvider from '../context/MetaDataProvider';
import ItemProvider from '../context/ItemProvider';
import SearchProvider from '../context/SearchProvider';

const AuthenticatedAppProviders = ({children}) => {
  return (
    <MetaDataProvider>
      <ItemProvider>
        <SearchProvider>{children}</SearchProvider>
      </ItemProvider>
    </MetaDataProvider>
  );
};

AuthenticatedAppProviders.propTypes = {
  children: PropTypes.node.isRequired
};

export default AuthenticatedAppProviders;
