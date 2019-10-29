import React, {useEffect} from 'react';
import PropTypes from 'prop-types';
import HorizontalCardBar from '../components/common/HorizontalCardBar';
import LoadingIndicator from '../components/common/LoadingIndicator';
import {useItems} from '../context/ItemProvider';
import ItemType from '../constants/ItemType';
import MeleeItemList from '../components/common/MeleeItemList';
import {useGlobalMetadataManager} from '../context/FirebaseProvider';
import ScrollableContainer from '../components/common/ScrollableContainer';

const CategoryScreen = ({navigation}) => {
  const {loading, data: docs, setCollectionName, clearData} = useItems();
  const {globalMetadata} = useGlobalMetadataManager();
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

        Object.keys(globalMetadata.ammoMetadata).map((x) => {
          sorted[x] = data[x];
        });

        return Object.entries(sorted).map(([name, items]) => {
          if (items && items.length)
            return <HorizontalCardBar title={name} items={items} key={name} />;
        });
      }
      default:
        return Object.entries(data).map(([name, items]) => {
          if (items && items.length)
            return <HorizontalCardBar title={name} items={items} key={name} />;
        });
    }
  };

  return <ScrollableContainer fluid>{renderList(docs)}</ScrollableContainer>;
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
