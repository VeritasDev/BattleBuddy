import React, {useEffect} from 'react';
import AuthenticationProvider from './src/context/AuthenticationProvider';
import App from './App';
import auth from '@react-native-firebase/auth';

const bootstrapAnonAuth = async () => {
  try {
    const credentials = await auth().signInAnonymously();
    return credentials;
  } catch (e) {
    switch (e.code) {
      case 'auth/operation-not-allowed':
        console.log('Enable anonymous in your firebase console.');
        break;
      default:
        console.error(e);
        break;
    }
  }
};

const AppProviders = () => {
  useEffect(() => {
    bootstrapAnonAuth();
  }, []);

  return (
    <AuthenticationProvider>
      <App />
    </AuthenticationProvider>
  );
};

export default AppProviders;
