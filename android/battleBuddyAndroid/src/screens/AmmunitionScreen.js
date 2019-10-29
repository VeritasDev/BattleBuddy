import React, {useEffect} from 'react';
import LoadingIndicator from '../components/common/LoadingIndicator';
import AmmunitionProvider, {useAmmunition} from '../context/AmmunitionProvider';
import ItemSectionList from '../components/common/ItemSectionList';

const AmmunitionScreen = () => {
  const {loading, getAmmoByCaliber, data} = useAmmunition();

  useEffect(() => {
    getAmmoByCaliber(true);
  }, []);

  if (loading) return <LoadingIndicator />;

  return <ItemSectionList data={data} />;
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
