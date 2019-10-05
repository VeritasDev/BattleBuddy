import React from 'react';
import PropTypes from 'prop-types';
import MetaDataProvider from '../context/MetaDataProvider';

const AuthenticatedAppProviders = ({children}) => {
  return <MetaDataProvider>{children}</MetaDataProvider>;
};

AuthenticatedAppProviders.propTypes = {
  children: PropTypes.node.isRequired
};

export default AuthenticatedAppProviders;
