import React from 'react';
import AuthenticationProvider from './src/context/AuthenticationProvider';
import App from './App';
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
