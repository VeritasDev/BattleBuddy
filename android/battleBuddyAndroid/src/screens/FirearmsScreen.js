import React, {useEffect} from 'react';
import ScrollableContainer from '../components/common/ScrollableContainer';
import FirearmsProvider, {useFirearms} from '../context/FirearmsProvider';
import LoadingIndicator from '../components/common/LoadingIndicator';
import HorizontalCardBar from '../components/common/HorizontalCardBar';

const FirearmsScreen = () => {
  const {loading, getFirearmsByClass, data} = useFirearms();

  useEffect(() => {
    getFirearmsByClass();
  }, []);

  if (loading) return <LoadingIndicator />;

  return (
    <ScrollableContainer fluid>
      {data &&
        Object.entries(data).map(([title, items]) => (
          <HorizontalCardBar key={title} title={title} items={items} />
        ))}
    </ScrollableContainer>
  );
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
