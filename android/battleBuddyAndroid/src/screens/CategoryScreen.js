import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import ScrollableContainer from '../components/common/ScrollableContainer';
import HorizontalCardBar from '../components/common/HorizontalCardBar';
import LoadingIndicator from '../components/common/LoadingIndicator';
import {useItems} from '../context/ItemProvider';
import ItemType from '../constants/ItemType';
import MeleeItemList from '../components/common/MeleeItemList';

const CategoryScreen = ({navigation}) => {
  const {loading, data: docs, setCollectionName, clearData} = useItems();
  const {collection} = navigation.state.params;

  useEffect(() => {
    setCollectionName(collection);

    return clearData;
  }, [collection]);

  if (loading) return <LoadingIndicator />;

  return (
    <ScrollableContainer>
      {collection !== ItemType.melee ? (
        Object.entries(docs).map(([name, items]) => {
          if (items.length)
            return <HorizontalCardBar title={name} items={items} key={name} />;
        })
      ) : (
        <MeleeItemList items={docs} />
      )}
    </ScrollableContainer>
  );
};

CategoryScreen.navigationOptions = (screenProps) => ({
  title: screenProps.navigation.getParam('text'),
  headerStyle: {
    backgroundColor: '#151515'
  },
  headerTintColor: '#FF491C',
  headerTitleStyle: {
    fontSize: 28
  }
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
