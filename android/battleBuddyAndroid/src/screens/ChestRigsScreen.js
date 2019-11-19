import React, {useEffect} from 'react';
import ChestRigProvider, {useChestRigs} from '../context/ChestRigProvider';
import LoadingIndicator from '../components/common/LoadingIndicator';
import ItemSectionList from '../components/common/ItemSectionList';

const ChestRigsScreen = () => {
  const {loading, getChestRigsByClass, data} = useChestRigs();

  useEffect(() => {
    getChestRigsByClass();
  }, []);

  if (loading) return <LoadingIndicator />;

  return <ItemSectionList data={data} localized />;
};

const Wrapper = () => (
  <ChestRigProvider>
    <ChestRigsScreen />
  </ChestRigProvider>
);

Wrapper.navigationOptions = {
  title: 'Chest Rigs'
};

export default Wrapper;
