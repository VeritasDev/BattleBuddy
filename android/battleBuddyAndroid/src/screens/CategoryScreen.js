import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import LoadingIndicator from '../components/common/LoadingIndicator';
import {useItems} from '../context/ItemProvider';
import ItemType from '../constants/ItemType';
import MeleeItemList from '../components/common/MeleeItemList';
import ItemSectionList from '../components/common/ItemSectionList';

const CategoryScreen = ({navigation}) => {
  const {loading, data: docs, setCollectionName, clearData} = useItems();
  const {collection} = navigation.state.params;

  useEffect(() => {
    setCollectionName(collection);

    return clearData;
  }, [collection]);

  if (loading) return <LoadingIndicator />;

  const renderList = (data) => {
    switch (collection) {
      case ItemType.melee:
        return <MeleeItemList items={data} />;
      default:
        return <ItemSectionList localized data={data} />;
    }
  };

  return renderList(docs);
};

CategoryScreen.navigationOptions = (screenProps) => ({
  title: screenProps.navigation.getParam('text')
});

CategoryScreen.propTypes = {
  navigation: PropTypes.shape({
    state: PropTypes.shape({
      params: PropTypes.shape({
        text: PropTypes.string.isRequired,
        collection: PropTypes.string.isRequired
      })
    })
  })
};

export default CategoryScreen;
