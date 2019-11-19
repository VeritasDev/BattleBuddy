import React, {useEffect} from 'react';
import HelmetsProvider, {useHelmets} from '../context/HelmetsProvider';
import LoadingIndicator from '../components/common/LoadingIndicator';
import ItemSectionList from '../components/common/ItemSectionList';

const HelmetsScreen = () => {
  const {loading, getAllHelmetsByClass, data} = useHelmets();

  useEffect(() => {
    getAllHelmetsByClass();
  }, []);

  if (loading) return <LoadingIndicator />;

  return <ItemSectionList data={data} localized />;
};

const Wrapper = () => (
  <HelmetsProvider>
    <HelmetsScreen />
  </HelmetsProvider>
);

Wrapper.navigationOptions = {
  title: 'Helmets'
};

export default Wrapper;
