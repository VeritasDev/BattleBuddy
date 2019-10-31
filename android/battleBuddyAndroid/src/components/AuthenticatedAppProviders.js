import React from 'react';
import PropTypes from 'prop-types';
import ItemProvider from '../context/ItemProvider';
import SearchProvider from '../context/SearchProvider';
import BallisticsProvider from '../context/BallisticsProvider';

const AuthenticatedAppProviders = ({children}) => {
  return (
    <ItemProvider>
      <BallisticsProvider>
        <SearchProvider>{children}</SearchProvider>
      </BallisticsProvider>
    </ItemProvider>
  );
};

AuthenticatedAppProviders.propTypes = {
  children: PropTypes.node.isRequired
};

export default AuthenticatedAppProviders;
