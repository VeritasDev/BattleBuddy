import React, {useEffect} from 'react';
import LoadingIndicator from '../components/common/LoadingIndicator';
import ItemSectionList from '../components/common/ItemSectionList';
import VisorsProvider, {useVisors} from '../context/VisorsProvider';

const VisorsScreen = () => {
  const {loading, getAllVisorsByClass, data} = useVisors();

  useEffect(() => {
    getAllVisorsByClass();
  }, []);

  if (loading) return <LoadingIndicator />;

  return <ItemSectionList data={data} localized />;
};

const Wrapper = () => (
  <VisorsProvider>
    <VisorsScreen />
  </VisorsProvider>
);

Wrapper.navigationOptions = {
  title: 'Visors'
};

export default Wrapper;
