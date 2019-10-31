import React from 'react';
import App from './App';
import AuthenticationProvider from './src/context/AuthenticationProvider';
import FirebaseProvider from './src/context/FirebaseProvider';

const AppProviders = () => {
  return (
    <FirebaseProvider>
      <AuthenticationProvider>
        <App />
      </AuthenticationProvider>
    </FirebaseProvider>
  );
};

export default AppProviders;
