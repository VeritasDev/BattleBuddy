import React, {useEffect} from 'react';
import FirearmsProvider, {useFirearms} from '../context/FirearmsProvider';
import LoadingIndicator from '../components/common/LoadingIndicator';
import ItemSectionList from '../components/common/ItemSectionList';

const FirearmsScreen = () => {
  const {loading, getFirearmsByClass, data} = useFirearms();

  useEffect(() => {
    getFirearmsByClass();
  }, []);

  if (loading) return <LoadingIndicator />;

  return <ItemSectionList data={data} localized />;
};

const Wrapper = () => (
  <FirearmsProvider>
    <FirearmsScreen />
  </FirearmsProvider>
);

Wrapper.navigationOptions = {
  title: 'Firearms'
};

export default Wrapper;
