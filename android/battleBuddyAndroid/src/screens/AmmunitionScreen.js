import React, {useEffect} from 'react';
import LoadingIndicator from '../components/common/LoadingIndicator';
import HorizontalCardBar from '../components/common/HorizontalCardBar';
import AmmunitionProvider, {useAmmunition} from '../context/AmmunitionProvider';
import ScrollableContainer from '../components/common/ScrollableContainer';

const AmmunitionScreen = () => {
  const {loading, getAmmoByCaliber, data} = useAmmunition();

  useEffect(() => {
    getAmmoByCaliber(true);
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
  <AmmunitionProvider>
    <AmmunitionScreen />
  </AmmunitionProvider>
);

Wrapper.navigationOptions = {
  title: 'Ammunition'
};

export default Wrapper;
