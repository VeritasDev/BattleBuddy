import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import ScrollableContainer from '../components/common/ScrollableContainer';
import HorizontalCardBar from '../components/common/HorizontalCardBar';
import LoadingIndicator from '../components/common/LoadingIndicator';
import {useItems} from '../context/ItemProvider';
import ItemType from '../constants/ItemType';
import MeleeItemList from '../components/common/MeleeItemList';
import {useGlobalMetadataManager} from '../context/FirebaseProvider';

const CategoryScreen = ({navigation}) => {
  const {loading, data: docs, setCollectionName, clearData} = useItems();
  const {globalMetadata} = useGlobalMetadataManager();
  // console.log(globalMetadata);
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
      case ItemType.ammo: {
        const sorted = {};
        const sortedAmmoMetadata = {};

        Object.entries(globalMetadata.ammoMetadata).sort(
          ([aKey, aValue], [bKey, bValue]) => {
            if (aValue.index < bValue.index) {
              sortedAmmoMetadata[aKey] = aValue;
            } else {
              sortedAmmoMetadata[bKey] = bValue;
            }
          }
        );
        console.log(sortedAmmoMetadata);
        Object.keys(globalMetadata.ammoMetadata).map((x) => {
          sorted[x] = data[x];
        });

        return Object.entries(sorted).map(([name, items]) => {
          if (items.length)
            return <HorizontalCardBar title={name} items={items} key={name} />;
        });
      }
      default:
        return Object.entries(data).map(([name, items]) => {
          if (items.length)
            return <HorizontalCardBar title={name} items={items} key={name} />;
        });
    }
  };

  return <ScrollableContainer>{renderList(docs)}</ScrollableContainer>;
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