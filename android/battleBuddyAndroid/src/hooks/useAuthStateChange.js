import {useState, useEffect} from 'react';
import auth from '@react-native-firebase/auth';

const useAuthStateChange = () => {
  const [state, setState] = useState();

  useEffect(() => {
    const subscriber = auth().onAuthStateChanged((authState) => {
      setState(authState);
    });

    return subscriber;
  }, []);

  return state;
};

export default useAuthStateChange;
