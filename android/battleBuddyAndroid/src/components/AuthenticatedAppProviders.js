import React from 'react';
import PropTypes from 'prop-types';
import MetaDataProvider from '../context/MetaDataProvider';
import ItemProvider from '../context/ItemProvider';

const AuthenticatedAppProviders = ({children}) => {
  return (
    <MetaDataProvider>
      <ItemProvider>{children}</ItemProvider>
    </MetaDataProvider>
  );
};

AuthenticatedAppProviders.propTypes = {
  children: PropTypes.node.isRequired
};

export default AuthenticatedAppProviders;
